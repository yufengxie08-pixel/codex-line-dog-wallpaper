#!/bin/bash

set -euo pipefail

LINE_DOG_REPOSITORY="yufengxie08-pixel/codex-line-dog-wallpaper"
LINE_DOG_MARKETPLACE="line-dog-wallpaper"
LINE_DOG_PLUGIN="codex-line-dog-wallpaper"
LINE_DOG_TEMP=""

cleanup() {
  [ -z "$LINE_DOG_TEMP" ] || /bin/rm -rf "$LINE_DOG_TEMP"
}
trap cleanup EXIT

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd -P || true)"
if [ -n "$script_dir" ] && [ -d "$script_dir/plugins/$LINE_DOG_PLUGIN" ]; then
  repo_root="$script_dir"
else
  LINE_DOG_TEMP="$(/usr/bin/mktemp -d "${TMPDIR:-/tmp}/line-dog-wallpaper.XXXXXX")"
  archive="$LINE_DOG_TEMP/source.tar.gz"
  /usr/bin/curl -fL --proto '=https' --tlsv1.2 \
    "https://github.com/$LINE_DOG_REPOSITORY/archive/refs/heads/main.tar.gz" -o "$archive"
  /usr/bin/tar -xzf "$archive" -C "$LINE_DOG_TEMP"
  repo_root="$(/usr/bin/find "$LINE_DOG_TEMP" -mindepth 1 -maxdepth 1 -type d -name 'codex-line-dog-wallpaper-*' | /usr/bin/head -n 1)"
  [ -n "$repo_root" ] || { printf 'Could not unpack the repository.\n' >&2; exit 1; }
fi

"$repo_root/plugins/$LINE_DOG_PLUGIN/scripts/install-wallpaper-macos.sh"

if [ "${LINE_DOG_SKIP_CODEX_PLUGIN:-0}" != "1" ] && command -v codex >/dev/null 2>&1; then
  if codex plugin marketplace list 2>/dev/null \
    | /usr/bin/awk -v marketplace="$LINE_DOG_MARKETPLACE" '$1 == marketplace { found = 1 } END { exit !found }'; then
    codex plugin marketplace upgrade "$LINE_DOG_MARKETPLACE" >/dev/null
  else
    codex plugin marketplace add "$LINE_DOG_REPOSITORY" --ref main >/dev/null
  fi
  codex plugin add "$LINE_DOG_PLUGIN@$LINE_DOG_MARKETPLACE" >/dev/null
  printf 'Codex plugin installed: %s@%s\n' "$LINE_DOG_PLUGIN" "$LINE_DOG_MARKETPLACE"
else
  printf 'The Line Dog full-skin runtime is installed. Codex CLI was not found, so the optional plugin card was skipped.\n'
fi

printf 'Done. The default skin is Yellow Together. Ask Codex to “切换线条小狗皮肤” to see all four choices.\n'
printf 'Quit and reopen Codex once if the skin is not already visible.\n'
