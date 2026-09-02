#!/bin/bash

set -Eeuo pipefail

LINE_DOG_HOME="${HOME:?A macOS home directory is required}"
LINE_DOG_STATE_ROOT="$LINE_DOG_HOME/Library/Application Support/CodexLineDogWallpaper"
LINE_DOG_ENGINE_ROOT="$LINE_DOG_STATE_ROOT/engine"
LINE_DOG_DEFER_FILE="$LINE_DOG_HOME/Library/Application Support/CodexDreamSkinStudio/autostart-defer-current-pid"
LINE_DOG_FAILURE_STAMP="$LINE_DOG_STATE_ROOT/last-autostart-failure"
LINE_DOG_PORT="9341"

[ -f "$LINE_DOG_ENGINE_ROOT/scripts/common-macos.sh" ] || exit 1
# shellcheck disable=SC1090
. "$LINE_DOG_ENGINE_ROOT/scripts/common-macos.sh"
discover_codex_app
require_signed_node_runtime

current_pid="$(codex_main_pids | /usr/bin/head -n 1)"
[ -n "$current_pid" ] || exit 0

if [ -f "$LINE_DOG_DEFER_FILE" ]; then
  deferred_pid="$(/bin/cat "$LINE_DOG_DEFER_FILE" 2>/dev/null || true)"
  if [ "$deferred_pid" = "$current_pid" ]; then
    exit 0
  fi
  /bin/rm -f "$LINE_DOG_DEFER_FILE"
fi

injector_pid="$(/bin/ps -axo pid=,command= | /usr/bin/awk -v injector="$INJECTOR" -v port="$LINE_DOG_PORT" '
  index($0, injector) && index($0, "--watch --port " port " --theme-dir ") && !found { found = $1 }
  END { if (found) print found }
')"

if verified_cdp_endpoint "$LINE_DOG_PORT"; then
  if [ -n "$injector_pid" ] && /bin/kill -0 "$injector_pid" 2>/dev/null; then
    exit 0
  fi
  exec "$LINE_DOG_ENGINE_ROOT/scripts/start-dream-skin-macos.sh" --port "$LINE_DOG_PORT"
fi

if [ -f "$LINE_DOG_FAILURE_STAMP" ]; then
  last_failure="$(/bin/cat "$LINE_DOG_FAILURE_STAMP" 2>/dev/null || true)"
  now="$(/bin/date +%s)"
  case "$last_failure" in
    ''|*[!0-9]*) ;;
    *) [ $((now - last_failure)) -ge 120 ] || exit 0 ;;
  esac
fi

if ! "$LINE_DOG_ENGINE_ROOT/scripts/start-dream-skin-macos.sh" --port "$LINE_DOG_PORT" --restart-existing; then
  /bin/date +%s > "$LINE_DOG_FAILURE_STAMP"
  exit 1
fi
/bin/rm -f "$LINE_DOG_FAILURE_STAMP"
