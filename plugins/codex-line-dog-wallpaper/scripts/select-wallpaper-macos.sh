#!/bin/bash

set -euo pipefail
. "$(cd "$(dirname "$0")" && pwd -P)/lib-macos.sh"

usage() {
  printf '%s\n' \
    'Usage:' \
    '  select-wallpaper-macos.sh --list' \
    '  select-wallpaper-macos.sh --current' \
    '  select-wallpaper-macos.sh <wallpaper-id> [--restart-if-needed]'
}

case "${1:-}" in
  --list)
    line_dog_list_wallpapers
    exit 0
    ;;
  --current)
    current_id="$(line_dog_selected_wallpaper_id)"
    printf '%s\t%s\t%s\t%s\n' "$current_id" \
      "$(line_dog_wallpaper_name_zh "$current_id")" \
      "$(line_dog_wallpaper_name_en "$current_id")" \
      "$(line_dog_wallpaper_asset "$current_id")"
    exit 0
    ;;
  ''|-h|--help)
    usage
    exit 0
    ;;
esac

wallpaper_id="$1"
shift
restart_if_needed="false"
while [ "$#" -gt 0 ]; do
  case "$1" in
    --restart-if-needed) restart_if_needed="true" ;;
    *) usage >&2; line_dog_fail "Unknown argument: $1" ;;
  esac
  shift
done

line_dog_validate_wallpaper_id "$wallpaper_id" || {
  usage >&2
  line_dog_fail "Unknown wallpaper: $wallpaper_id"
}

line_dog_require_macos
line_dog_prepare_dirs
line_dog_install_engine_if_needed
line_dog_source_engine
line_dog_snapshot_previous_state
line_dog_stage_theme "$wallpaper_id"
line_dog_disable_u7_agent
line_dog_install_runtime
line_dog_defer_current_codex
line_dog_write_plist
line_dog_load_agent

wallpaper_name="$(line_dog_wallpaper_name_zh "$wallpaper_id") / $(line_dog_wallpaper_name_en "$wallpaper_id")"
if line_dog_hot_apply_if_possible; then
  printf 'Wallpaper applied: %s\n' "$wallpaper_name"
  exit 0
fi

if [ "$restart_if_needed" = "true" ] && [ "${LINE_DOG_TEST_MODE:-0}" != "1" ]; then
  printf 'Restarting Codex once to apply: %s\n' "$wallpaper_name"
  "$LINE_DOG_ENGINE_ROOT/scripts/start-dream-skin-macos.sh" \
    --port "$LINE_DOG_PORT" --restart-existing
  exit 0
fi

printf 'Wallpaper staged: %s. Restart Codex once to apply it.\n' "$wallpaper_name"
