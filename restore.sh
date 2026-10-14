#!/usr/bin/env bash
# Applies the snapshotted VS Code config on the machine you're running this on
# (e.g. your work machine). Safe: backs up anything it would overwrite.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -s)" in
  Darwin) USER_DIR="$HOME/Library/Application Support/Code/User" ;;
  Linux)  USER_DIR="$HOME/.config/Code/User" ;;
  *)      echo "Unsupported OS. On Windows copy $REPO/User to %APPDATA%\\Code\\User manually."; exit 1 ;;
esac

if [[ -f "$USER_DIR/settings.json" ]]; then
  BACKUP="$USER_DIR/backup-$(date +%Y%m%d-%H%M%S)"
  mkdir -p "$BACKUP"
  cp "$USER_DIR/settings.json" "$USER_DIR/keybindings.json" "$BACKUP/" 2>/dev/null || true
  cp -R "$USER_DIR/snippets" "$BACKUP/snippets" 2>/dev/null || true
  echo "Backed up existing config to $BACKUP"
fi

mkdir -p "$USER_DIR/snippets"
cp "$REPO/User/settings.json"    "$USER_DIR/settings.json"
cp "$REPO/User/keybindings.json" "$USER_DIR/keybindings.json"
cp "$REPO"/User/snippets/*.json  "$USER_DIR/snippets/" 2>/dev/null || true
echo "Config restored."

if [[ -f "$REPO/extensions.txt" ]]; then
  echo
  echo "Installing extensions (skips ones already present)..."
  while read -r ext; do
    [[ -z "$ext" ]] && continue
    code --install-extension "$ext" --force >/dev/null 2>&1 \
      && echo "  ok   $ext" || echo "  FAIL $ext"
  done < "$REPO/extensions.txt"
fi

echo
echo "Done. Reload VS Code (Cmd+Shift+P -> Developer: Reload Window)."
