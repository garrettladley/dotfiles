#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
test_root="$(mktemp -d)"
trap 'rm -rf -- "$test_root"' EXIT

installed_home="${test_root}/installed"
mkdir -p "$installed_home"
printf '[alias]\n\tlocal = status\n' >"${installed_home}/.gitconfig"

HOME="$installed_home" GIT_CONFIG_NOSYSTEM=1 \
  "$repo_root/install.sh" --skip-brew >"${test_root}/first-install.log"

HOME="$installed_home" GIT_CONFIG_NOSYSTEM=1 \
  git config --global --get-all include.path |
  grep -Fx "$repo_root/git/config" >/dev/null
HOME="$installed_home" GIT_CONFIG_NOSYSTEM=1 \
  git config --global --get alias.local |
  grep -Fx status >/dev/null

link_count=0
while IFS= read -r link; do
  target="$(readlink "$link")"
  [[ "$target" == "$repo_root"/* ]]
  ((link_count += 1))
done < <(find "$installed_home" -type l)

expected_link_count="$(
  find "$repo_root/fish" "$repo_root/ghostty" -type f | wc -l
)"
for skill in "$repo_root/skills"/*; do
  [[ -d "$skill" ]] || continue
  ((expected_link_count += 2))
done
[[ "$link_count" -eq "$expected_link_count" ]]

first_config="$(cksum <"${installed_home}/.gitconfig")"
HOME="$installed_home" GIT_CONFIG_NOSYSTEM=1 \
  "$repo_root/install.sh" --skip-brew >"${test_root}/second-install.log"
second_config="$(cksum <"${installed_home}/.gitconfig")"
[[ "$first_config" == "$second_config" ]]
[[ ! -s "${test_root}/second-install.log" ]]

conflict_home="${test_root}/conflict"
mkdir -p "${conflict_home}/.config/fish"
printf 'local config\n' >"${conflict_home}/.config/fish/config.fish"
find "$conflict_home" -print | sort >"${test_root}/before-conflict"

if HOME="$conflict_home" GIT_CONFIG_NOSYSTEM=1 \
  "$repo_root/install.sh" --skip-brew 2>"${test_root}/conflict.log"; then
  printf 'expected conflicting installation to fail\n' >&2
  exit 1
fi

grep -F 'refusing to change anything' "${test_root}/conflict.log" >/dev/null
find "$conflict_home" -print | sort >"${test_root}/after-conflict"
cmp "${test_root}/before-conflict" "${test_root}/after-conflict"

printf 'install test: passed\n'
