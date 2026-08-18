#!/usr/bin/env bash

set -euo pipefail

# Keep screenshots in the clipboard by default. Hold Control while taking a
# screenshot to use the opposite destination for that one capture.
defaults write com.apple.screencapture target clipboard

# Use the fastest keyboard repeat values macOS accepts. These take effect after
# restarting the Mac (or logging out and back in).
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

# Use the highest native trackpad tracking speed.
defaults write -g com.apple.trackpad.scaling -float 3.0

# Reload the menu-bar process so the setting takes effect without a logout.
killall SystemUIServer >/dev/null 2>&1 || true

printf 'macOS preferences applied; log out and back in or restart if any change is not active yet.\n'
