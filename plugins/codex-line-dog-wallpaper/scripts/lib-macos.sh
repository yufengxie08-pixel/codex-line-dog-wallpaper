#!/bin/bash

set -euo pipefail

LINE_DOG_PLUGIN_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
LINE_DOG_HOME="${HOME:?A macOS home directory is required}"
LINE_DOG_ENGINE_SOURCE="$LINE_DOG_PLUGIN_ROOT/vendor/codex-dream-skin-studio"
LINE_DOG_STATE_ROOT="$LINE_DOG_HOME/Library/Application Support/CodexLineDogWallpaper"
LINE_DOG_ENGINE_ROOT="$LINE_DOG_STATE_ROOT/engine"
LINE_DOG_DREAM_STATE="$LINE_DOG_HOME/Library/Application Support/CodexDreamSkinStudio"
LINE_DOG_THEME_DIR="$LINE_DOG_DREAM_STATE/theme"
LINE_DOG_BACKUP_ROOT="$LINE_DOG_STATE_ROOT/backups"
LINE_DOG_RUNTIME_ROOT="$LINE_DOG_STATE_ROOT/runtime"
LINE_DOG_LABEL="com.openai.codex.line-dog-wallpaper.autostart"
LINE_DOG_PLIST="$LINE_DOG_HOME/Library/LaunchAgents/$LINE_DOG_LABEL.plist"
LINE_DOG_U7_LABEL="com.openai.codex.u7-wallpaper.autostart"
LINE_DOG_U7_PLIST="$LINE_DOG_HOME/Library/LaunchAgents/$LINE_DOG_U7_LABEL.plist"
LINE_DOG_PORT="9341"
LINE_DOG_DEFAULT_WALLPAPER_ID="yellow-together"
LINE_DOG_SELECTION_FILE="$LINE_DOG_STATE_ROOT/selected-wallpaper"

line_dog_fail() {
  printf 'Line Dog Full Skin: %s\n' "$*" >&2
  exit 1
}

line_dog_wallpaper_ids() {
  printf '%s\n' yellow-together blue-sky blue-daily pink-friends
}

line_dog_wallpaper_asset() {
  case "${1:-}" in
    yellow-together) printf '%s\n' "$LINE_DOG_PLUGIN_ROOT/assets/line-dog-yellow-together-3840x2400.jpg" ;;
    blue-sky) printf '%s\n' "$LINE_DOG_PLUGIN_ROOT/assets/line-dog-blue-sky-3840x2400.jpg" ;;
    blue-daily) printf '%s\n' "$LINE_DOG_PLUGIN_ROOT/assets/line-dog-blue-daily-3840x2400.jpg" ;;
    pink-friends) printf '%s\n' "$LINE_DOG_PLUGIN_ROOT/assets/line-dog-pink-friends-3840x2400.jpg" ;;
    *) return 1 ;;
  esac
}

line_dog_theme_asset() {
  case "${1:-}" in
    yellow-together) printf '%s\n' "$LINE_DOG_PLUGIN_ROOT/assets/themes/yellow-together.json" ;;
    blue-sky) printf '%s\n' "$LINE_DOG_PLUGIN_ROOT/assets/themes/blue-sky.json" ;;
    blue-daily) printf '%s\n' "$LINE_DOG_PLUGIN_ROOT/assets/themes/blue-daily.json" ;;
    pink-friends) printf '%s\n' "$LINE_DOG_PLUGIN_ROOT/assets/themes/pink-friends.json" ;;
    *) return 1 ;;
  esac
}

line_dog_wallpaper_name_zh() {
  case "${1:-}" in
    yellow-together) printf '%s\n' '黄色相伴' ;;
    blue-sky) printf '%s\n' '蓝天追风' ;;
    blue-daily) printf '%s\n' '蓝色日常' ;;
    pink-friends) printf '%s\n' '粉色伙伴' ;;
    *) return 1 ;;
  esac
}

line_dog_wallpaper_name_en() {
  case "${1:-}" in
    yellow-together) printf '%s\n' 'Yellow Together' ;;
    blue-sky) printf '%s\n' 'Blue Sky Adventure' ;;
    blue-daily) printf '%s\n' 'Blue Daily Life' ;;
    pink-friends) printf '%s\n' 'Pink Friends' ;;
    *) return 1 ;;
  esac
}

line_dog_validate_wallpaper_id() {
  line_dog_wallpaper_asset "${1:-}" >/dev/null 2>&1
}

line_dog_selected_wallpaper_id() {
  local selected="${LINE_DOG_WALLPAPER_ID:-}"
  if [ -z "$selected" ] && [ -f "$LINE_DOG_SELECTION_FILE" ]; then
    selected="$(/bin/cat "$LINE_DOG_SELECTION_FILE")"
  fi
  [ -n "$selected" ] || selected="$LINE_DOG_DEFAULT_WALLPAPER_ID"
  line_dog_validate_wallpaper_id "$selected" || selected="$LINE_DOG_DEFAULT_WALLPAPER_ID"
  printf '%s\n' "$selected"
}

line_dog_list_wallpapers() {
  local selected id default_marker current_marker
  selected="$(line_dog_selected_wallpaper_id)"
  while IFS= read -r id; do
    default_marker=""
    current_marker=""
    [ "$id" != "$LINE_DOG_DEFAULT_WALLPAPER_ID" ] || default_marker="default"
    [ "$id" != "$selected" ] || current_marker="current"
    printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
      "$id" "$(line_dog_wallpaper_name_zh "$id")" "$(line_dog_wallpaper_name_en "$id")" \
      "$(line_dog_wallpaper_asset "$id")" "$default_marker" "$current_marker"
  done < <(line_dog_wallpaper_ids)
}

line_dog_require_macos() {
  [ "$(/usr/bin/uname -s)" = "Darwin" ] || line_dog_fail "macOS is required."
  [ -d "$LINE_DOG_ENGINE_SOURCE" ] || line_dog_fail "Bundled Dream Skin engine is missing."
  [ -f "$LINE_DOG_PLUGIN_ROOT/assets/theme.json" ] || line_dog_fail "theme.json is missing."
  local id
  while IFS= read -r id; do
    [ -f "$(line_dog_wallpaper_asset "$id")" ] \
      || line_dog_fail "The wallpaper asset for $id is missing."
    [ -f "$(line_dog_theme_asset "$id")" ] \
      || line_dog_fail "The skin palette for $id is missing."
  done < <(line_dog_wallpaper_ids)
}

line_dog_prepare_dirs() {
  /bin/mkdir -p "$LINE_DOG_STATE_ROOT" "$LINE_DOG_BACKUP_ROOT" "$LINE_DOG_RUNTIME_ROOT" \
    "$LINE_DOG_DREAM_STATE" "$LINE_DOG_HOME/Library/LaunchAgents" "$LINE_DOG_HOME/.codex"
  /bin/chmod 700 "$LINE_DOG_STATE_ROOT" "$LINE_DOG_BACKUP_ROOT" "$LINE_DOG_RUNTIME_ROOT" \
    "$LINE_DOG_DREAM_STATE" 2>/dev/null || true
}

line_dog_install_engine_if_needed() {
  local source_version installed_version staging backup
  source_version="$(/usr/bin/tr -d '[:space:]' < "$LINE_DOG_ENGINE_SOURCE/VERSION")"
  installed_version=""
  if [ -f "$LINE_DOG_ENGINE_ROOT/VERSION" ]; then
    installed_version="$(/usr/bin/tr -d '[:space:]' < "$LINE_DOG_ENGINE_ROOT/VERSION")"
  fi
  if [ -f "$LINE_DOG_ENGINE_ROOT/scripts/start-dream-skin-macos.sh" ] \
    && [ -f "$LINE_DOG_ENGINE_ROOT/scripts/injector.mjs" ] \
    && [ -f "$LINE_DOG_ENGINE_ROOT/assets/dream-skin.css" ] \
    && [ "$installed_version" = "$source_version" ]; then
    return 0
  fi

  staging="$(/usr/bin/mktemp -d "$LINE_DOG_STATE_ROOT/engine-stage.XXXXXX")"
  /usr/bin/rsync -a --exclude '.DS_Store' "$LINE_DOG_ENGINE_SOURCE/" "$staging/"
  /bin/chmod 700 "$staging/scripts/"*.sh 2>/dev/null || true
  backup="$LINE_DOG_STATE_ROOT/engine-previous"
  if [ -e "$backup" ] && [ ! -e "$LINE_DOG_ENGINE_ROOT" ]; then
    /bin/mv "$backup" "$LINE_DOG_ENGINE_ROOT"
  fi
  [ ! -e "$backup" ] || /bin/rm -rf "$backup"
  if [ -e "$LINE_DOG_ENGINE_ROOT" ]; then
    /bin/mv "$LINE_DOG_ENGINE_ROOT" "$backup"
  fi
  if /bin/mv "$staging" "$LINE_DOG_ENGINE_ROOT"; then
    [ ! -e "$backup" ] || /bin/rm -rf "$backup"
  else
    [ ! -e "$backup" ] || /bin/mv "$backup" "$LINE_DOG_ENGINE_ROOT"
    line_dog_fail "Could not install the isolated Line Dog Dream Skin engine."
  fi
}

line_dog_source_engine() {
  # shellcheck disable=SC1090
  . "$LINE_DOG_ENGINE_ROOT/scripts/common-macos.sh"
  discover_codex_app
  require_signed_node_runtime
}

line_dog_snapshot_previous_state() {
  local marker="$LINE_DOG_BACKUP_ROOT/snapshot-complete"
  [ -f "$marker" ] && return 0

  if [ -d "$LINE_DOG_THEME_DIR" ]; then
    /bin/mkdir -p "$LINE_DOG_BACKUP_ROOT/theme-before-install"
    /usr/bin/rsync -a "$LINE_DOG_THEME_DIR/" "$LINE_DOG_BACKUP_ROOT/theme-before-install/"
  else
    : > "$LINE_DOG_BACKUP_ROOT/no-previous-theme"
  fi

  if /bin/launchctl print "gui/$(/usr/bin/id -u)/$LINE_DOG_U7_LABEL" >/dev/null 2>&1; then
    : > "$LINE_DOG_BACKUP_ROOT/u7-was-active"
  fi
  /bin/date -u '+%Y-%m-%dT%H:%M:%SZ' > "$marker"
  /bin/chmod -R go-rwx "$LINE_DOG_BACKUP_ROOT" 2>/dev/null || true
}

line_dog_stage_theme() {
  local wallpaper_id="${1:-}"
  [ -n "$wallpaper_id" ] || wallpaper_id="$(line_dog_selected_wallpaper_id)"
  line_dog_validate_wallpaper_id "$wallpaper_id" \
    || line_dog_fail "Unknown wallpaper: $wallpaper_id"

  /bin/mkdir -p "$LINE_DOG_THEME_DIR"
  local image_tmp="$LINE_DOG_THEME_DIR/.line-dog-background.$$.tmp"
  local theme_tmp="$LINE_DOG_THEME_DIR/.line-dog-theme.$$.tmp"
  local selection_tmp="$LINE_DOG_STATE_ROOT/.selected-wallpaper.$$.tmp"
  /bin/cp "$(line_dog_wallpaper_asset "$wallpaper_id")" "$image_tmp"
  /bin/cp "$(line_dog_theme_asset "$wallpaper_id")" "$theme_tmp"
  /usr/bin/printf '%s\n' "$wallpaper_id" > "$selection_tmp"
  /bin/chmod 600 "$image_tmp" "$theme_tmp" "$selection_tmp"
  /bin/mv -f "$image_tmp" "$LINE_DOG_THEME_DIR/background.jpg"
  /bin/mv -f "$theme_tmp" "$LINE_DOG_THEME_DIR/theme.json"
  /bin/mv -f "$selection_tmp" "$LINE_DOG_SELECTION_FILE"
}

line_dog_disable_u7_agent() {
  [ "${LINE_DOG_TEST_MODE:-0}" != "1" ] || return 0
  /bin/launchctl bootout "gui/$(/usr/bin/id -u)/$LINE_DOG_U7_LABEL" >/dev/null 2>&1 || true
}

line_dog_current_codex_pid() {
  codex_main_pids | /usr/bin/head -n 1
}

line_dog_defer_current_codex() {
  local current_pid
  current_pid="$(line_dog_current_codex_pid 2>/dev/null || true)"
  if [ -n "$current_pid" ]; then
    /usr/bin/printf '%s\n' "$current_pid" > "$LINE_DOG_DREAM_STATE/autostart-defer-current-pid"
    /bin/chmod 600 "$LINE_DOG_DREAM_STATE/autostart-defer-current-pid"
  fi
}

line_dog_install_runtime() {
  /bin/cp "$LINE_DOG_PLUGIN_ROOT/scripts/autostart-macos.sh" "$LINE_DOG_RUNTIME_ROOT/autostart-macos.sh"
  /bin/chmod 700 "$LINE_DOG_RUNTIME_ROOT/autostart-macos.sh"
}

line_dog_write_plist() {
  local temporary="$LINE_DOG_PLIST.$$.tmp"
  /bin/rm -f "$temporary"
  /usr/bin/plutil -create xml1 "$temporary"
  /usr/bin/plutil -insert Label -string "$LINE_DOG_LABEL" "$temporary"
  /usr/bin/plutil -insert ProgramArguments -json "[\"/bin/bash\",\"$LINE_DOG_RUNTIME_ROOT/autostart-macos.sh\"]" "$temporary"
  /usr/bin/plutil -insert RunAtLoad -bool true "$temporary"
  /usr/bin/plutil -insert StartInterval -integer 15 "$temporary"
  /usr/bin/plutil -insert ProcessType -string Background "$temporary"
  /usr/bin/plutil -insert StandardOutPath -string "$LINE_DOG_STATE_ROOT/launchd.log" "$temporary"
  /usr/bin/plutil -insert StandardErrorPath -string "$LINE_DOG_STATE_ROOT/launchd-error.log" "$temporary"
  /bin/chmod 600 "$temporary"
  /bin/mv -f "$temporary" "$LINE_DOG_PLIST"
}

line_dog_load_agent() {
  local domain="gui/$(/usr/bin/id -u)"
  if [ "${LINE_DOG_TEST_MODE:-0}" = "1" ]; then
    /usr/bin/plutil -lint "$LINE_DOG_PLIST" >/dev/null
    return 0
  fi
  /bin/launchctl bootout "$domain/$LINE_DOG_LABEL" >/dev/null 2>&1 || true
  /bin/launchctl bootstrap "$domain" "$LINE_DOG_PLIST"
  /bin/launchctl enable "$domain/$LINE_DOG_LABEL"
  /bin/launchctl kickstart "$domain/$LINE_DOG_LABEL" >/dev/null 2>&1 || true
}

line_dog_hot_apply_if_possible() {
  [ "${LINE_DOG_TEST_MODE:-0}" != "1" ] || return 1
  if verified_cdp_endpoint "$LINE_DOG_PORT"; then
    hot_reapply_theme "$LINE_DOG_PORT" 10000
    return $?
  fi
  return 1
}
