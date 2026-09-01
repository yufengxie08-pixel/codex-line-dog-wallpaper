#!/bin/bash

set -u

LINE_DOG_HOME="${HOME:?A macOS home directory is required}"
LINE_DOG_STATE_ROOT="$LINE_DOG_HOME/Library/Application Support/CodexLineDogWallpaper"
LINE_DOG_THEME_JSON="$LINE_DOG_HOME/Library/Application Support/CodexDreamSkinStudio/theme/theme.json"
LINE_DOG_ENGINE_ROOT="$LINE_DOG_HOME/.codex/codex-dream-skin-studio"
LINE_DOG_LABEL="com.openai.codex.line-dog-wallpaper.autostart"

agent="not-loaded"
theme="unknown"
engine="missing"

if /bin/launchctl print "gui/$(/usr/bin/id -u)/$LINE_DOG_LABEL" >/dev/null 2>&1; then
  agent="loaded"
fi
if [ -f "$LINE_DOG_THEME_JSON" ]; then
  theme="$(/usr/bin/plutil -extract name raw -o - "$LINE_DOG_THEME_JSON" 2>/dev/null || \
    /usr/bin/sed -n 's/.*"name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' "$LINE_DOG_THEME_JSON" | /usr/bin/head -n 1)"
fi
if [ -x "$LINE_DOG_ENGINE_ROOT/scripts/status-dream-skin-macos.sh" ]; then
  engine="$($LINE_DOG_ENGINE_ROOT/scripts/status-dream-skin-macos.sh --short 2>/dev/null || true)"
  [ -n "$engine" ] || engine="installed"
fi

printf 'agent=%s\n' "$agent"
printf 'theme=%s\n' "$theme"
printf 'engine=%s\n' "$engine"
printf 'state=%s\n' "$LINE_DOG_STATE_ROOT"
