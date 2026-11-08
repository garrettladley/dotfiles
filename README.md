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

After Homebrew installs the Brewfile, the script uses `dockutil` to replace the
pinned Dock items with Zed, Ghostty, Google Chrome, Slack, and Spotify, in that
order, followed by Downloads. Finder and Trash remain implicit. Recent apps are
hidden; running apps can still appear while open. The complete layout is built
in a temporary preferences file, imported only after success, and followed by
one Dock restart. Each install restores this layout. With `--skip-brew`,
`dockutil` and all five apps must already be installed.

The [Raycast hotkey reference](raycast/README.md) documents application and
window-management shortcuts. These are managed in Raycast and are not applied
by the installer.

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

`macos/.hushlogin` is linked to the home directory on macOS to suppress login
banners, including the "Last login" message shown when opening a terminal.

## Development

```console
just format
just ci
```

`just ci` runs the same formatting, linting, and installation checks used by
GitHub Actions.
