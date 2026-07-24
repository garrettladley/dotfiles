# dotfiles

Personal macOS configuration for Git, Fish, Ghostty, and agent skills.

## Install

Clone the repository, inspect the intended changes, and install:

```console
./install.sh --dry-run
./install.sh
```

The installer checks every managed target before changing anything. If an
existing file or an unexpected symlink would be replaced, installation stops
and reports all conflicts. It never deletes, moves, or overwrites them.

Use `--skip-brew` to install configuration without satisfying the `Brewfile`.
Use `--check` to verify an existing installation.

Git credentials and Fish secrets remain machine-local. Authenticate GitHub
separately with:

```console
gh auth login
gh auth setup-git
```

Configure the appropriate Git identity on each machine:

```console
git config --global user.name "Your Name"
git config --global user.email "you@example.com"
```

Store Fish secrets in `~/.config/fish/secrets.fish`.

## Managed files

Files under `fish/` and `ghostty/` mirror their respective configuration
directories and are discovered automatically. Each directory under `skills/`
is linked into both supported agent skill directories. Adding a Fish function,
Ghostty setting file, or personal skill does not require registering individual
files with the installer.

## Development

```console
just format
just ci
```

`just ci` runs the same formatting, linting, and installation checks used by
GitHub Actions.
