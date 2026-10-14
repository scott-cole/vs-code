# vscode-config

Portable snapshot of my VS Code setup, so a fresh machine can be configured in one command.

## Why this exists alongside built-in Settings Sync

VS Code's built-in Settings Sync (sign in with GitHub) is the primary mechanism and
handles live, continuous sync. This repo is a backup path for when that isn't available —
locked-down work machines, a different sign-in account, corporate proxy blocking OAuth,
or simply wanting to see the config as reviewable text in git.

## Restoring on the work machine

```sh
git clone https://github.com/scott-cole/vs-code.git ~/dev/vscode-config
cd ~/dev/vscode-config
./restore.sh
```

The repo is public, so that clone needs no credentials — useful on locked-down
machines where you can't add an SSH key. If you'd rather it be private, clone with
SSH instead: `git clone git@github.com:scott-cole/vs-code.git`.

`restore.sh` detects macOS vs Linux, backs up any existing config first, then installs
the extensions listed in `extensions.txt`.

On Windows, copy `User/` over `%APPDATA%\Code\User` manually and run the extension loop
from `extensions.txt` by hand.

## After changing settings on the personal machine

```sh
./sync.sh
git add -A && git commit -m "update vscode config" && git push
```

## Things that do NOT travel

- **Fonts.** VS Code syncs the *name* of the font, not the file. Install the font on
  every machine or `editor.fontFamily` silently falls back:
  ```sh
  brew install --cask font-jetbrains-mono-nerd-font
  ```
- **`node_modules`-dependent behaviour.** `typescript.tsdk` points at each project's
  own TypeScript, so no action needed, but the setting only takes effect once VS Code
  prompts you to "Use Workspace Version" inside a project.
- **Sign-ins** for GitLens, Console Ninja, and similar extensions.
