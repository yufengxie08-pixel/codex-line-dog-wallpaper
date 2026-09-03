#!/bin/bash

set -euo pipefail
. "$(cd "$(dirname "$0")" && pwd -P)/lib-macos.sh"

line_dog_require_macos
line_dog_prepare_dirs
line_dog_install_engine_if_needed
line_dog_source_engine
line_dog_snapshot_previous_state
line_dog_stage_theme
line_dog_disable_u7_agent
line_dog_install_runtime
line_dog_defer_current_codex
line_dog_write_plist
line_dog_load_agent

if line_dog_hot_apply_if_possible; then
  printf 'Line Dog Full Skin is active now.\n'
else
  printf 'Line Dog Full Skin is installed. Quit and reopen Codex once to activate it.\n'
fi
printf 'The previous theme and U7 files were preserved in %s.\n' "$LINE_DOG_BACKUP_ROOT"
