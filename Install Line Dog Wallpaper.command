#!/bin/bash

set -euo pipefail

printf 'Installing Line Dog Full Skin for Codex…\n\n'
installer_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
if [ -f "$installer_root/install.sh" ] && [ -d "$installer_root/plugins/codex-line-dog-wallpaper" ]; then
  /bin/bash "$installer_root/install.sh"
else
  /bin/bash -c "$(/usr/bin/curl -fsSL --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/yufengxie08-pixel/codex-line-dog-wallpaper/main/install.sh)"
fi
printf '\nInstallation finished. Press Return to close this window.\n'
read -r _
