#!/usr/bin/env bash
set -euo pipefail

RICE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

copy_file() {
  local source=$1 target=$2 mode=644
  [[ -f $source ]] || { echo "Missing live file: $source" >&2; exit 1; }
  [[ -x $source ]] && mode=755
  install -Dm"$mode" -- "$source" "$target"
}

copy_directory() {
  local source_root=$1 target_root=$2 source relative
  while IFS= read -r -d '' source; do
    relative=${source#"$source_root"/}
    copy_file "$source" "$target_root/$relative"
  done < <(find "$source_root" -type f -print0)
}

hypr_files=(
  hyprland.lua monitors.lua input.lua bindings.lua looknfeel.lua autostart.lua
  hypridle.conf hyprlock.conf hyprsunset.conf xdph.conf
)

for file in "${hypr_files[@]}"; do
  copy_file "$HOME/.config/hypr/$file" "$RICE_DIR/config/hypr/$file"
done

copy_directory "$HOME/.config/waybar" "$RICE_DIR/config/waybar"
copy_directory "$HOME/.config/alacritty" "$RICE_DIR/config/alacritty"
copy_directory "$HOME/.config/foot" "$RICE_DIR/config/foot"
copy_directory "$HOME/.config/kitty" "$RICE_DIR/config/kitty"
copy_directory "$HOME/.config/ghostty" "$RICE_DIR/config/ghostty"
copy_directory "$HOME/.config/omarchy/themes/tree" "$RICE_DIR/omarchy/themes/tree"
copy_directory "$HOME/.config/omarchy/plugins/tmac.notifications" \
  "$RICE_DIR/config/omarchy/plugins/tmac.notifications"

copy_file "$HOME/.config/mimeapps.list" "$RICE_DIR/config/mimeapps.list"
copy_file "$HOME/.config/xdg-terminals.list" "$RICE_DIR/config/xdg-terminals.list"
copy_file "$HOME/.config/omarchy-scaling-tui.json" "$RICE_DIR/config/omarchy-scaling-tui.json"
copy_file "$HOME/.config/omarchy/shell.json" "$RICE_DIR/config/omarchy/shell.json"
copy_file "$HOME/.config/omarchy/current/theme/waybar.css" \
  "$RICE_DIR/config/omarchy/current/theme/waybar.css"
copy_file "$HOME/.var/app/com.discordapp.Discord/config/discord-flags.conf" \
  "$RICE_DIR/var/app/com.discordapp.Discord/config/discord-flags.conf"

copy_file "$HOME/.local/bin/omarchy-toggle-waybar" \
  "$RICE_DIR/local/bin/omarchy-toggle-waybar"
copy_file "$HOME/.local/bin/omarchy-restart-waybar" \
  "$RICE_DIR/local/bin/omarchy-restart-waybar"

desktop_files=(
  betaflight-configurator.desktop
  chromium.desktop
  com.discordapp.Discord.desktop
  com.orcaslicer.OrcaSlicer.desktop
  spotify.desktop
)

for file in "${desktop_files[@]}"; do
  copy_file "$HOME/.local/share/applications/$file" \
    "$RICE_DIR/local/share/applications/$file"
done

if rg -n -i '(api[_-]?key|access[_-]?token|authorization)[[:space:]]*[:=][[:space:]]*[^[:space:]]{8}' \
    "$RICE_DIR/config" "$RICE_DIR/local" "$RICE_DIR/var" "$RICE_DIR/omarchy"; then
  echo "Possible secret detected; review before committing." >&2
  exit 1
fi

git -C "$RICE_DIR/../.." diff --check
echo "Snapshot refreshed. Review with: git -C '$RICE_DIR/../..' status --short"
