---
name: line-dog-wallpaper
description: Install, apply, diagnose, restore, or uninstall the Line Dog wallpaper collection in the Codex macOS desktop app.
---

# Line Dog Wallpaper

Use this skill when the user asks to install, apply, repair, check, restore, or remove the Line Dog Codex chat wallpaper collection. Use the separate `line-dog-wallpaper-selector` skill when the request is specifically to preview or switch among wallpapers.

## Safety and compatibility

- This plugin supports macOS only.
- It uses a verified loopback-only debugging endpoint in the official Codex desktop app and never modifies the signed app bundle.
- Installing Line Dog disables the U7 launch agent when present but does not delete U7 files.
- The first installation snapshots the current Dream Skin theme. Restoration uses that snapshot.
- If Codex is already open without the verified endpoint, never interrupt the active conversation. The installer defers that process and asks the user to quit and reopen Codex once.

## Commands

Run scripts relative to this skill's plugin root.

- Install: `scripts/install-wallpaper-macos.sh`
- Reapply: `scripts/apply-wallpaper-macos.sh`
- List or switch wallpapers: `scripts/select-wallpaper-macos.sh`
- Status: `scripts/status-macos.sh`
- Restore the previous theme: `scripts/restore-previous-macos.sh`
- Uninstall the wallpaper runtime: `scripts/uninstall-wallpaper-macos.sh`

Always run status before repair or restoration. Report whether a normal Codex reopen is required.
