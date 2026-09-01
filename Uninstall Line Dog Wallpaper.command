#!/bin/bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd -P)"
"$SCRIPT_DIR/uninstall.sh"
printf '\nUninstall finished. Press Return to close this window.\n'
read -r _
