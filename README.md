# dotfiles

Personal macOS configuration, installed from this checkout.

## Use

With [Homebrew](https://brew.sh) installed, run from the repository root:

```console
./install.sh --dry-run
./install.sh
./install.sh --check
```

See `./install.sh --help` for flags. The [installer](install.sh) checks managed
file targets for conflicts before making changes; existing files and unrelated
symlinks must be resolved manually.

## Architecture

- **Linked configuration:** Files under [fish/](fish/), [ghostty/](ghostty/), and
  [zed/](zed/) are discovered recursively and symlinked into application
  configuration directories. Each directory under [skills/](skills/) is linked
  into the agent skill directories. Target paths live in [install.sh](install.sh).
  Add files within these trees without registering them individually.
- **Git include:** [git/config](git/config) is included from the user's global
  Git configuration, preserving machine-local settings and credentials.
- **Applied state:** [Brewfile](Brewfile) defines packages and applications;
  [macos/defaults.sh](macos/defaults.sh) defines native preferences and the Dock
  layout. Rerun the installer after changing these sources. On macOS, the
  installer also registers and selects Fish as the login shell; terminals
  inherit it. A logout may be needed for shell or preference changes.
- **Reference only:** [Raycast shortcuts](raycast/README.md) are maintained in
  Raycast and are not applied by the installer.

## Development

Run `just format` to format and `just ci` to validate. The [justfile](justfile)
defines the checks, [tests/install.sh](tests/install.sh) exercises installation,
and [CI](.github/workflows/ci.yml) runs the same validation.
