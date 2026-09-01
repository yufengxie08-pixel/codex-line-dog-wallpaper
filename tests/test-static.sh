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

dimensions="$(/usr/bin/sips -g pixelWidth -g pixelHeight "$PLUGIN_ROOT/assets/line-dog-wallpaper-3840x2400.jpg")"
/usr/bin/grep -q 'pixelWidth: 3840' <<<"$dimensions"
/usr/bin/grep -q 'pixelHeight: 2400' <<<"$dimensions"

if /usr/bin/grep -RE '/Users/[A-Za-z0-9._-]+/' "$REPO_ROOT" \
  --exclude-dir=.git --exclude='*.jpg' --exclude='*.png' >/dev/null 2>&1; then
  printf 'Hard-coded user path found.\n' >&2
  exit 1
fi

/usr/bin/grep -q '"name": "line-dog-wallpaper"' "$REPO_ROOT/.agents/plugins/marketplace.json"
/usr/bin/grep -q '"name": "codex-line-dog-wallpaper"' "$PLUGIN_ROOT/.codex-plugin/plugin.json"
/usr/bin/grep -q '"id": "line-dog-wallpaper"' "$PLUGIN_ROOT/assets/theme.json"

test_home="$(/usr/bin/mktemp -d "${TMPDIR:-/tmp}/line-dog-test-home.XXXXXX")"
cleanup() { /bin/rm -rf "$test_home"; }
trap cleanup EXIT
HOME="$test_home" LINE_DOG_TEST_MODE=1 LINE_DOG_SKIP_CODEX_PLUGIN=1 "$REPO_ROOT/install.sh" >/dev/null
[ -f "$test_home/Library/Application Support/CodexDreamSkinStudio/theme/background.jpg" ]
[ -f "$test_home/Library/Application Support/CodexDreamSkinStudio/theme/theme.json" ]
[ -f "$test_home/Library/LaunchAgents/com.openai.codex.line-dog-wallpaper.autostart.plist" ]
[ -f "$test_home/.codex/codex-dream-skin-studio/scripts/injector.mjs" ]

printf 'Static checks passed.\n'
