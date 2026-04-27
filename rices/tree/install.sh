#!/usr/bin/env bash
set -euo pipefail

RICE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.config/omarchy-rice-backup-$(date +%Y%m%d-%H%M%S)"

echo "==> Omarchy 'tree' rice installer"
echo ""
echo "This will install the tree rice into your home directory."
echo "A backup of any overwritten files will be saved to:"
echo "  $BACKUP_DIR"
echo ""
read -rp "Continue? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

mkdir -p "$BACKUP_DIR"

backup_and_copy() {
  local src="$1"
  local dest="$2"
  local dest_dir
  dest_dir="$(dirname "$dest")"
  mkdir -p "$dest_dir"
  if [[ -e "$dest" ]]; then
    local backup_dest="$BACKUP_DIR/${dest#$HOME/}"
    mkdir -p "$(dirname "$backup_dest")"
    cp -r "$dest" "$backup_dest"
  fi
  cp -r "$src" "$dest"
}

echo ""
echo "==> Installing hyprland config..."
for f in "$RICE_DIR/config/hypr/"*; do
  backup_and_copy "$f" "$HOME/.config/hypr/$(basename "$f")"
done

echo "==> Installing waybar config..."
for f in "$RICE_DIR/config/waybar/"*; do
  backup_and_copy "$f" "$HOME/.config/waybar/$(basename "$f")"
done

echo "==> Installing mimeapps and terminal list..."
backup_and_copy "$RICE_DIR/config/mimeapps.list"      "$HOME/.config/mimeapps.list"
backup_and_copy "$RICE_DIR/config/xdg-terminals.list" "$HOME/.config/xdg-terminals.list"

echo "==> Installing desktop entries..."
for f in "$RICE_DIR/local/share/applications/"*; do
  backup_and_copy "$f" "$HOME/.local/share/applications/$(basename "$f")"
done

echo "==> Installing tree theme..."
mkdir -p "$HOME/.config/omarchy/themes"
backup_and_copy "$RICE_DIR/omarchy/themes/tree" "$HOME/.config/omarchy/themes/tree"

echo "==> Installing backgrounds..."
mkdir -p "$HOME/.config/omarchy/backgrounds/tokyo-night"
cp "$RICE_DIR/omarchy/backgrounds/tokyo-night/tree.png" \
   "$HOME/.config/omarchy/backgrounds/tokyo-night/tree.png"

echo "==> Applying theme..."
if command -v omarchy-theme-set &>/dev/null; then
  omarchy-theme-set tree
else
  echo "    (omarchy-theme-set not found — apply the 'tree' theme manually via Super+Ctrl+T)"
fi

echo "==> Reloading Hyprland..."
if command -v hyprctl &>/dev/null && hyprctl version &>/dev/null 2>&1; then
  hyprctl reload
else
  echo "    (Hyprland not running — reload manually after starting your session)"
fi

echo ""
echo "Done! Backup saved to: $BACKUP_DIR"
echo ""
echo "Notes:"
echo "  - Open a new terminal to see the updated colors and opacity"
echo "  - The tree wallpaper is available in Super+Ctrl+W → Background"
