# dotfiles

Personal macOS configuration for Git, Fish, Ghostty, Zed, and agent skills.

## Install

Clone the repository, inspect the intended changes, and install:

```console
./install.sh --dry-run
./install.sh
```

The installer checks every managed target before changing anything. If an
existing file or an unexpected symlink would be replaced, installation stops
and reports all conflicts. It never deletes, moves, or overwrites them.

Use `--skip-brew` to install configuration without satisfying the `Brewfile`,
or `--skip-macos` to leave managed macOS preferences and the login shell
unchanged.
Use `--check` to verify an existing installation.

## macOS preferences

The installer applies the macOS preferences in `macos/defaults.sh` on macOS.
See that script for the managed settings. Use `./install.sh --skip-macos` to
omit these settings, including while testing the installer.

The installer also registers the Homebrew-installed Fish executable in
`/etc/shells` and selects it as the current user's macOS login shell. Registering
Fish may prompt for an administrator password. Ghostty inherits this login shell
instead of naming Fish in its own configuration.

Log out and back in, or restart, if macOS does not immediately recognize a
login-shell or preference change.

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

Files under `fish/`, `ghostty/`, and `zed/` mirror their respective
configuration directories and are discovered automatically. Each directory
under `skills/` is linked into both supported agent skill directories. Adding a
Fish function, application setting, or personal skill does not require
registering individual files with the installer.

`.hushlogin` is linked to the home directory to suppress macOS login banners,
including the "Last login" message shown when opening a terminal.

## Development

```console
just format
just ci
```

`just ci` runs the same formatting, linting, and installation checks used by
GitHub Actions.
