#!/usr/bin/env bash
# Pulls this machine's VS Code config into this repo as a portable snapshot.
# Run this on your personal machine whenever you change settings.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
USER_DIR="$HOME/Library/Application Support/Code/User"

mkdir -p "$REPO/User/snippets"

cp "$USER_DIR/settings.json"   "$REPO/User/settings.json"
cp "$USER_DIR/keybindings.json" "$REPO/User/keybindings.json"
cp "$USER_DIR"/snippets/*.json  "$REPO/User/snippets/" 2>/dev/null || true

code --list-extensions | sort > "$REPO/extensions.txt"

echo "Snapshot updated in $REPO"
echo "Extensions: $(wc -l < "$REPO/extensions.txt" | tr -d ' ')"
echo
echo "Next: git add -A && git commit -m 'update vscode config' && git push"
