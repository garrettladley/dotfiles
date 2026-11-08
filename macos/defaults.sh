#!/usr/bin/env bash

set -euo pipefail

# Homebrew installs dockutil and these applications before this script runs.
if ! command -v dockutil >/dev/null 2>&1; then
  printf 'macOS: dockutil is required; install the Brewfile first\n' >&2
  exit 1
fi

dock_apps=(
  /Applications/Zed.app
  /Applications/Ghostty.app
  "/Applications/Google Chrome.app"
  /Applications/Slack.app
  /Applications/Spotify.app
)
for item in "${dock_apps[@]}" "${HOME}/Downloads"; do
  if [[ ! -d "$item" ]]; then
    printf 'macOS: missing Dock item: %s\n' "$item" >&2
    exit 1
  fi
done

# Build the complete layout off-screen. A failed rebuild leaves the live Dock
# untouched; only the finished preferences are imported below.
dock_stage="$(mktemp -d)"
trap 'rm -rf -- "$dock_stage"' EXIT
dock_plist="${dock_stage}/com.apple.dock.plist"
defaults export com.apple.dock "$dock_plist"

dock_args=(--remove all --no-restart)
for app in "${dock_apps[@]}"; do
  dock_args+=(--add "$app")
done
# Finder and Trash are implicit; Downloads must be restored after clearing.
dock_args+=(--add "${HOME}/Downloads")
dockutil "${dock_args[@]}" "$dock_plist"
# dockutil can report success even if saving fails; verify before publishing.
dock_items="$(dockutil --list "$dock_plist" | cut -f1)"
expected_dock_items="$(printf '%s\n' Zed Ghostty 'Google Chrome' Slack Spotify Downloads)"
if [[ "$dock_items" != "$expected_dock_items" ]]; then
  printf 'macOS: staged Dock layout does not match; leaving the Dock unchanged\n' >&2
  exit 1
fi
plutil -replace show-recents -bool false "$dock_plist"
plutil -lint "$dock_plist" >/dev/null

# Keep screenshots in the clipboard by default. Hold Control while taking a
# screenshot to use the opposite destination for that one capture.
defaults write com.apple.screencapture target clipboard

# Use the fastest keyboard repeat values macOS accepts. These take effect after
# restarting the Mac (or logging out and back in).
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

# Use the highest native trackpad tracking speed.
defaults write -g com.apple.trackpad.scaling -float 3.0

# Publish the complete Dock layout and refresh it once.
defaults import com.apple.dock "$dock_plist"
killall Dock >/dev/null 2>&1 || true

# Reload the menu-bar process so the setting takes effect without a logout.
killall SystemUIServer >/dev/null 2>&1 || true

printf 'macOS preferences applied; log out and back in or restart if any change is not active yet.\n'
