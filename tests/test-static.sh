#!/bin/bash

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
PLUGIN_ROOT="$REPO_ROOT/plugins/codex-line-dog-wallpaper"

for script in "$REPO_ROOT"/*.sh "$REPO_ROOT"/*.command "$PLUGIN_ROOT/scripts/"*.sh; do
  /bin/bash -n "$script"
done

/usr/bin/python3 -m json.tool "$REPO_ROOT/.agents/plugins/marketplace.json" >/dev/null
/usr/bin/python3 -m json.tool "$PLUGIN_ROOT/.codex-plugin/plugin.json" >/dev/null
/usr/bin/python3 -m json.tool "$PLUGIN_ROOT/assets/theme.json" >/dev/null
for theme in "$PLUGIN_ROOT"/assets/themes/*.json; do
  /usr/bin/python3 -m json.tool "$theme" >/dev/null
done
/usr/bin/grep -q 'data-dream-theme-id' \
  "$PLUGIN_ROOT/vendor/codex-dream-skin-studio/assets/renderer-inject.js"
/usr/bin/grep -q 'assistant-message' \
  "$PLUGIN_ROOT/vendor/codex-dream-skin-studio/assets/renderer-inject.js"
/usr/bin/grep -q 'data-dream-theme-id\^="line-dog-".*assistant-message' \
  "$PLUGIN_ROOT/vendor/codex-dream-skin-studio/assets/dream-skin.css"
/usr/bin/grep -q 'background-color: transparent !important' \
  "$PLUGIN_ROOT/vendor/codex-dream-skin-studio/assets/dream-skin.css"
/usr/bin/grep -q 'data-line-dog-icon' \
  "$PLUGIN_ROOT/vendor/codex-dream-skin-studio/assets/renderer-inject.js"
/usr/bin/grep -q 'Line Dog Full Skin 2.0' \
  "$PLUGIN_ROOT/vendor/codex-dream-skin-studio/assets/dream-skin.css"

wallpaper_count=0
for wallpaper in "$PLUGIN_ROOT"/assets/line-dog-*-3840x2400.jpg; do
  dimensions="$(/usr/bin/sips -g pixelWidth -g pixelHeight -g profile "$wallpaper")"
  /usr/bin/grep -q 'pixelWidth: 3840' <<<"$dimensions"
  /usr/bin/grep -q 'pixelHeight: 2400' <<<"$dimensions"
  /usr/bin/grep -q 'profile: sRGB IEC61966-2.1' <<<"$dimensions"
  wallpaper_count=$((wallpaper_count + 1))
done
[ "$wallpaper_count" -eq 4 ]

list_output="$(HOME="$(/usr/bin/mktemp -d "${TMPDIR:-/tmp}/line-dog-list-home.XXXXXX")" \
  "$PLUGIN_ROOT/scripts/select-wallpaper-macos.sh" --list)"
[ "$(/usr/bin/printf '%s\n' "$list_output" | /usr/bin/wc -l | /usr/bin/tr -d ' ')" -eq 4 ]
/usr/bin/grep -q $'^yellow-together\t黄色相伴\tYellow Together\t' <<<"$list_output"
/usr/bin/grep -q $'\tdefault\tcurrent$' <<<"$list_output"

if /usr/bin/grep -RE '/Users/[A-Za-z0-9._-]+/' "$REPO_ROOT" \
  --exclude-dir=.git --exclude='*.jpg' --exclude='*.png' >/dev/null 2>&1; then
  printf 'Hard-coded user path found.\n' >&2
  exit 1
fi

/usr/bin/grep -q '"name": "line-dog-wallpaper"' "$REPO_ROOT/.agents/plugins/marketplace.json"
/usr/bin/grep -q '"name": "codex-line-dog-wallpaper"' "$PLUGIN_ROOT/.codex-plugin/plugin.json"
/usr/bin/grep -q '"id": "line-dog-yellow-together"' "$PLUGIN_ROOT/assets/theme.json"

if /usr/bin/mdfind 'kMDItemCFBundleIdentifier == "com.openai.codex"' | /usr/bin/grep -q .; then
  test_home="$(/usr/bin/mktemp -d "${TMPDIR:-/tmp}/line-dog-test-home.XXXXXX")"
  cleanup() { /bin/rm -rf "$test_home"; }
  trap cleanup EXIT
  HOME="$test_home" LINE_DOG_TEST_MODE=1 LINE_DOG_SKIP_CODEX_PLUGIN=1 "$REPO_ROOT/install.sh" >/dev/null
  [ -f "$test_home/Library/Application Support/CodexDreamSkinStudio/theme/background.jpg" ]
  [ -f "$test_home/Library/Application Support/CodexDreamSkinStudio/theme/theme.json" ]
  [ -f "$test_home/Library/LaunchAgents/com.openai.codex.line-dog-wallpaper.autostart.plist" ]
  isolated_engine="$test_home/Library/Application Support/CodexLineDogWallpaper/engine"
  [ -f "$isolated_engine/scripts/injector.mjs" ]
  [ -f "$isolated_engine/assets/dream-skin.css" ]
  [ "$(/usr/bin/tr -d '[:space:]' < "$isolated_engine/VERSION")" = "1.6.1" ]
  /usr/bin/env node "$isolated_engine/scripts/injector.mjs" --check-payload \
    --theme-dir "$test_home/Library/Application Support/CodexDreamSkinStudio/theme" >/dev/null
  /usr/bin/cmp -s \
    "$test_home/Library/Application Support/CodexDreamSkinStudio/theme/background.jpg" \
    "$PLUGIN_ROOT/assets/line-dog-yellow-together-3840x2400.jpg"
  /usr/bin/grep -q '"id": "line-dog-yellow-together"' \
    "$test_home/Library/Application Support/CodexDreamSkinStudio/theme/theme.json"

  HOME="$test_home" LINE_DOG_TEST_MODE=1 \
    "$PLUGIN_ROOT/scripts/select-wallpaper-macos.sh" blue-daily --restart-if-needed >/dev/null
  /usr/bin/cmp -s \
    "$test_home/Library/Application Support/CodexDreamSkinStudio/theme/background.jpg" \
    "$PLUGIN_ROOT/assets/line-dog-blue-daily-3840x2400.jpg"
  /usr/bin/grep -q '^blue-daily$' \
    "$test_home/Library/Application Support/CodexLineDogWallpaper/selected-wallpaper"
  /usr/bin/grep -q '"id": "line-dog-blue-daily"' \
    "$test_home/Library/Application Support/CodexDreamSkinStudio/theme/theme.json"
else
  printf 'Official Codex app not present; isolated runtime test skipped.\n'
fi

printf 'Static checks passed.\n'
