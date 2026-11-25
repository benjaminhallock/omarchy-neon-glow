#!/usr/bin/env bash
# One-liner installer for the Neon Glow Omarchy theme.
#
#   curl -fsSL https://raw.githubusercontent.com/benjaminhallock/omarchy-neon-glow/main/install.sh | bash
#
# This installs the theme as a hand-written user theme, which matters: Omarchy
# strips Lua from themes installed with `omarchy theme install <git-url>`, and
# this theme's glow/flicker lives in hyprland.lua.

set -euo pipefail

REPO_URL="${NEON_GLOW_REPO:-https://github.com/benjaminhallock/omarchy-neon-glow.git}"
THEME_SLUG="neon-glow"
THEME_DIR="$HOME/.config/omarchy/themes/$THEME_SLUG"

command -v git >/dev/null 2>&1 || { echo "git is required" >&2; exit 1; }
command -v omarchy >/dev/null 2>&1 || { echo "Omarchy is required" >&2; exit 1; }

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "Fetching Neon Glow..."
git clone --quiet --depth 1 "$REPO_URL" "$tmp/repo"

if [[ -e "$THEME_DIR" ]]; then
  backup="${THEME_DIR}.bak.$(date +%s)"
  mv "$THEME_DIR" "$backup"
  echo "Backed up existing theme to: $backup"
fi

mkdir -p "$THEME_DIR"
cp -R "$tmp/repo/backgrounds" "$THEME_DIR/"
cp "$tmp/repo/colors.toml" \
   "$tmp/repo/hyprland.lua" \
   "$tmp/repo/preview.png" \
   "$tmp/repo/preview-unlock.png" \
   "$tmp/repo/unlock.png" \
   "$tmp/repo/README.md" \
   "$THEME_DIR/"

echo "Installed to: $THEME_DIR"

if [[ -n "${WAYLAND_DISPLAY:-}" || -n "${DISPLAY:-}" ]]; then
  omarchy theme set "$THEME_SLUG"
  echo "Neon Glow applied. Revert with: omarchy theme set gruvbox"
else
  echo "No graphical session detected. Apply later with: omarchy theme set $THEME_SLUG"
fi
