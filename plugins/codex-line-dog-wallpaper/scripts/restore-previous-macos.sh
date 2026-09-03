#!/bin/bash

set -euo pipefail
. "$(cd "$(dirname "$0")" && pwd -P)/lib-macos.sh"

line_dog_prepare_dirs
line_dog_install_engine_if_needed
line_dog_source_engine

domain="gui/$(/usr/bin/id -u)"
/bin/launchctl bootout "$domain/$LINE_DOG_LABEL" >/dev/null 2>&1 || true
/bin/rm -f "$LINE_DOG_PLIST"

if [ -d "$LINE_DOG_BACKUP_ROOT/theme-before-install" ]; then
  /bin/mkdir -p "$LINE_DOG_THEME_DIR"
  /usr/bin/rsync -a "$LINE_DOG_BACKUP_ROOT/theme-before-install/" "$LINE_DOG_THEME_DIR/"
  printf 'Restored the theme that was active before Line Dog Full Skin.\n'
else
  printf 'No previous theme backup was recorded; the current theme was left untouched.\n'
fi

if [ -f "$LINE_DOG_BACKUP_ROOT/u7-was-active" ] && [ -f "$LINE_DOG_U7_PLIST" ]; then
  line_dog_defer_current_codex
  /bin/launchctl bootout "$domain/$LINE_DOG_U7_LABEL" >/dev/null 2>&1 || true
  /bin/launchctl bootstrap "$domain" "$LINE_DOG_U7_PLIST"
  /bin/launchctl enable "$domain/$LINE_DOG_U7_LABEL"
  /bin/launchctl kickstart "$domain/$LINE_DOG_U7_LABEL" >/dev/null 2>&1 || true
  printf 'Re-enabled the preserved U7 autostart agent.\n'
fi

if line_dog_hot_apply_if_possible; then
  printf 'The restored theme is active now.\n'
else
  printf 'Quit and reopen Codex once to finish restoring the previous theme.\n'
fi
