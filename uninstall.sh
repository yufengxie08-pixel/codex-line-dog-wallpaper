#!/bin/bash

set -euo pipefail

LINE_DOG_PLUGIN="codex-line-dog-wallpaper"
LINE_DOG_MARKETPLACE="line-dog-wallpaper"
LINE_DOG_CACHE="$(codex plugin list 2>/dev/null | /usr/bin/awk -v plugin="$LINE_DOG_PLUGIN@$LINE_DOG_MARKETPLACE" '$1 == plugin { print $NF; exit }')"

if [ -n "$LINE_DOG_CACHE" ] && [ -x "$LINE_DOG_CACHE/scripts/uninstall-wallpaper-macos.sh" ]; then
  "$LINE_DOG_CACHE/scripts/uninstall-wallpaper-macos.sh"
else
  printf 'Run the uninstall script from a repository checkout or reinstall the plugin first.\n' >&2
  exit 1
fi

codex plugin remove "$LINE_DOG_PLUGIN" --marketplace "$LINE_DOG_MARKETPLACE" >/dev/null 2>&1 || true
codex plugin marketplace remove "$LINE_DOG_MARKETPLACE" >/dev/null 2>&1 || true
printf 'The Codex plugin registration was removed.\n'
