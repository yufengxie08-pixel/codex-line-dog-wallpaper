#!/bin/bash

set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"

"$SCRIPT_DIR/restore-previous-macos.sh"

LINE_DOG_HOME="${HOME:?A macOS home directory is required}"
LINE_DOG_RUNTIME_ROOT="$LINE_DOG_HOME/Library/Application Support/CodexLineDogWallpaper/runtime"
/bin/rm -f "$LINE_DOG_RUNTIME_ROOT/autostart-macos.sh"

printf 'Line Dog Wallpaper autostart was removed. Backups and the isolated Line Dog engine were preserved.\n'
