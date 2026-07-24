#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
brewfile="${repo_root}/Brewfile"
git_config="${repo_root}/git/config"

dry_run=false
check_only=false
skip_brew=false

usage() {
  cat <<'EOF'
Usage: ./install.sh [--check] [--dry-run] [--skip-brew]

  --check       Verify the current installation without changing it.
  --dry-run     Print the changes that would be made.
  --skip-brew   Do not install packages from the Brewfile.
EOF
}

while (($# > 0)); do
  case "$1" in
    --check)
      check_only=true
      ;;
    --dry-run)
      dry_run=true
      ;;
    --skip-brew)
      skip_brew=true
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      printf 'install: unsupported argument: %s\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

links=()

discover_tree() {
  local source_root=$1
  local target_root=$2
  local source
  local source_rel
  local target_rel

  while IFS= read -r -d '' source; do
    source_rel="${source#"${repo_root}/"}"
    target_rel="${source#"${source_root}/"}"
    links+=("${source_rel}|${target_root}/${target_rel}")
  done < <(find "$source_root" -type f -print0)
}

discover_skills() {
  local source
  local skill_name

  for source in "${repo_root}/skills"/*; do
    [[ -d "$source" ]] || continue
    skill_name="$(basename -- "$source")"
    links+=("skills/${skill_name}|${HOME}/.agents/skills/${skill_name}")
    links+=("skills/${skill_name}|${HOME}/.claude/skills/${skill_name}")
  done
}

discover_tree "${repo_root}/fish" "${HOME}/.config/fish"
discover_tree \
  "${repo_root}/ghostty" \
  "${HOME}/Library/Application Support/com.mitchellh.ghostty"
discover_skills

link_target() {
  local target=$1
  local target_dir
  local raw_target

  target_dir="$(cd -- "$(dirname -- "$target")" && pwd)"
  raw_target="$(readlink "$target")"

  if [[ "$raw_target" = /* ]]; then
    printf '%s\n' "$raw_target"
  else
    (cd -- "$target_dir" && cd -- "$(dirname -- "$raw_target")" &&
      printf '%s/%s\n' "$PWD" "$(basename -- "$raw_target")")
  fi
}

has_git_include() {
  local include

  while IFS= read -r include; do
    if [[ "$include" == "$git_config" ]]; then
      return 0
    fi
  done < <(git config --global --get-all include.path 2>/dev/null || true)

  return 1
}

preflight_links() {
  local conflict_count=0
  local entry
  local source_rel
  local source
  local target

  for entry in "${links[@]}"; do
    IFS='|' read -r source_rel target <<<"$entry"
    source="${repo_root}/${source_rel}"

    if [[ ! -e "$source" ]]; then
      printf 'install: missing source: %s\n' "$source" >&2
      ((conflict_count += 1))
    elif [[ -L "$target" ]]; then
      if [[ "$(link_target "$target")" != "$source" ]]; then
        printf 'install: conflict: %s -> %s\n' "$target" "$(readlink "$target")" >&2
        ((conflict_count += 1))
      fi
    elif [[ -e "$target" ]]; then
      printf 'install: conflict: %s already exists\n' "$target" >&2
      ((conflict_count += 1))
    fi
  done

  if ((conflict_count > 0)); then
    printf 'install: refusing to change anything; resolve the conflicts above\n' >&2
    return 1
  fi
}

check_installation() {
  local failed=false
  local entry
  local source_rel
  local source
  local target
  local command_name
  local required_commands=(
    bat difft fish fzf gh git delta jq just rg shellcheck shfmt tree zoxide
  )

  for entry in "${links[@]}"; do
    IFS='|' read -r source_rel target <<<"$entry"
    source="${repo_root}/${source_rel}"

    if [[ ! -L "$target" ]] || [[ "$(link_target "$target")" != "$source" ]]; then
      printf 'check: invalid link: %s\n' "$target" >&2
      failed=true
    fi
  done

  if ! has_git_include; then
    printf 'check: missing Git include: %s\n' "$git_config" >&2
    failed=true
  fi

  for command_name in "${required_commands[@]}"; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
      printf 'check: missing command: %s\n' "$command_name" >&2
      failed=true
    fi
  done

  if [[ "$failed" == true ]]; then
    return 1
  fi

  printf 'check: dotfiles are installed\n'
}

if [[ "$check_only" == true ]]; then
  check_installation
  exit
fi

preflight_links

if [[ "$dry_run" == true ]]; then
  for entry in "${links[@]}"; do
    IFS='|' read -r source_rel target <<<"$entry"
    source="${repo_root}/${source_rel}"
    if [[ ! -L "$target" ]]; then
      printf 'link: %s -> %s\n' "$target" "$source"
    fi
  done
  if ! has_git_include; then
    printf 'git include: %s\n' "$git_config"
  fi
  if [[ "$skip_brew" == false ]]; then
    printf 'brew bundle: %s\n' "$brewfile"
  fi
  exit
fi

if [[ "$skip_brew" == false ]]; then
  if ! command -v brew >/dev/null 2>&1; then
    printf 'install: Homebrew is required: https://brew.sh\n' >&2
    exit 1
  fi

  brew bundle check --file="$brewfile" >/dev/null 2>&1 ||
    brew bundle --file="$brewfile"
fi

for entry in "${links[@]}"; do
  IFS='|' read -r source_rel target <<<"$entry"
  source="${repo_root}/${source_rel}"

  if [[ ! -L "$target" ]]; then
    mkdir -p -- "$(dirname -- "$target")"
    ln -s -- "$source" "$target"
    printf 'linked: %s -> %s\n' "$target" "$source"
  fi
done

if ! has_git_include; then
  git config --global --add include.path "$git_config"
  printf 'configured Git include: %s\n' "$git_config"
fi
