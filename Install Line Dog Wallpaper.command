#!/bin/bash

set -euo pipefail

printf 'Installing Line Dog Full Skin for Codex…\n\n'
/bin/bash -c "$(/usr/bin/curl -fsSL --proto '=https' --tlsv1.2 https://raw.githubusercontent.com/yufengxie08-pixel/codex-line-dog-wallpaper/main/install.sh)"
printf '\nInstallation finished. Press Return to close this window.\n'
read -r _
