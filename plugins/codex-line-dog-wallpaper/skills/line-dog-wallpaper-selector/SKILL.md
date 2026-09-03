---
name: line-dog-wallpaper-selector
description: Preview, select, and switch among four complete Line Dog skins with matched light and dark palettes in the Codex macOS desktop app.
---

# Line Dog Full Skin Selector

Use this skill when the user asks to view, choose, or switch Line Dog wallpapers or complete skins.

## Gallery workflow

Resolve the plugin root as two directories above this `SKILL.md` file.

1. Run `scripts/select-wallpaper-macos.sh --list` from that plugin root. Its tab-separated fields are skin ID, Chinese name, English name, absolute preview path, default marker, and current marker.
2. If the user has not named a specific wallpaper, show all four images in the Codex conversation using their absolute paths and label the default and current choices. Ask which one to apply; do not switch until the user chooses.
3. When the user chooses, state that Codex may restart once if hot switching is unavailable, then run:

   `scripts/select-wallpaper-macos.sh <wallpaper-id> --restart-if-needed`

4. Report the selected name and whether its wallpaper, palette, glass surfaces, and icons were applied immediately or required a restart.

The valid IDs are `yellow-together`, `blue-sky`, `blue-daily`, and `pink-friends`. Do not accept arbitrary image paths. The script preserves the pre-install theme snapshot and disables rather than deletes the U7 launch agent.
