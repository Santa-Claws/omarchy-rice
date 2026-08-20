#!/usr/bin/env bash
set -euo pipefail

RICE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TARGET_HOME=${RICE_TARGET_HOME:-$HOME}
ASSUME_YES=false
INSTALL_PACKAGES=true
INSTALL_TOOLS=true
APPLY_LIVE=true

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Options:
  --yes                Do not prompt for confirmation
  --skip-packages      Skip Pacman/AUR packages and Flatpaks
  --skip-tools         Skip pinned Git helper tools
  --no-apply           Copy files without changing the live desktop session
  --target-home DIR    Restore into DIR (implies the three options above)
  -h, --help           Show this help
EOF
}

while (($#)); do
  case $1 in
    --yes)
      ASSUME_YES=true
      ;;
    --skip-packages)
      INSTALL_PACKAGES=false
      ;;
    --skip-tools)
      INSTALL_TOOLS=false
      ;;
    --no-apply)
      APPLY_LIVE=false
      ;;
    --target-home)
      [[ $# -ge 2 ]] || { echo "--target-home requires a directory" >&2; exit 2; }
      TARGET_HOME=$2
      shift
      INSTALL_PACKAGES=false
      INSTALL_TOOLS=false
      APPLY_LIVE=false
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if [[ $EUID -eq 0 ]]; then
  echo "Run this installer as your normal desktop user, not root." >&2
  exit 1
fi

if $APPLY_LIVE && ! command -v omarchy >/dev/null 2>&1; then
  echo "Omarchy is required. Install Omarchy first, then rerun this script." >&2
  exit 1
fi

mkdir -p "$TARGET_HOME"
BACKUP_DIR="$TARGET_HOME/.local/state/omarchy-rice/backups/$(date +%Y%m%d-%H%M%S)-$$"

echo "Omarchy Tree rice restore"
echo "  Target:  $TARGET_HOME"
echo "  Backup:  $BACKUP_DIR"
echo "  Packages: $INSTALL_PACKAGES"
echo "  Tools:    $INSTALL_TOOLS"
echo "  Apply:    $APPLY_LIVE"

if ! $ASSUME_YES; then
  read -r -p "Continue? [y/N] " answer
  [[ $answer =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }
fi

manifest_values() {
  sed -e '/^[[:space:]]*#/d' -e '/^[[:space:]]*$/d' "$1"
}

install_packages() {
  local -a packages aur_packages flatpaks missing
  mapfile -t packages < <(manifest_values "$RICE_DIR/packages/pacman.txt")
  mapfile -t aur_packages < <(manifest_values "$RICE_DIR/packages/aur.txt")
  mapfile -t flatpaks < <(manifest_values "$RICE_DIR/packages/flatpak.txt")

  missing=()
  for package in "${packages[@]}"; do
    pacman -Q "$package" >/dev/null 2>&1 || missing+=("$package")
  done
  if ((${#missing[@]})); then
    echo "==> Installing Pacman packages"
    omarchy pkg add "${missing[@]}"
  fi

  missing=()
  for package in "${aur_packages[@]}"; do
    pacman -Q "$package" >/dev/null 2>&1 || missing+=("$package")
  done
  if ((${#missing[@]})); then
    echo "==> Installing AUR packages"
    omarchy pkg aur add "${missing[@]}"
  fi

  echo "==> Installing Flatpaks"
  sudo flatpak remote-add --system --if-not-exists flathub \
    https://flathub.org/repo/flathub.flatpakrepo
  sudo flatpak install --system --noninteractive -y flathub "${flatpaks[@]}"

  sudo systemctl enable --now tailscaled.service
  if systemctl list-unit-files warp-svc.service >/dev/null 2>&1; then
    sudo systemctl enable --now warp-svc.service
  fi
}

backup_target() {
  local target=$1 relative backup_target_path
  if [[ -e $target || -L $target ]]; then
    relative=${target#"$TARGET_HOME"/}
    backup_target_path="$BACKUP_DIR/$relative"
    mkdir -p "$(dirname "$backup_target_path")"
    cp -a -- "$target" "$backup_target_path"
  fi
}

install_item() {
  local source=$1 target=$2 mode=644
  backup_target "$target"
  [[ -x $source ]] && mode=755
  install -Dm"$mode" -- "$source" "$target"
}

install_tree() {
  local source_root=$1 target_root=$2 source relative
  while IFS= read -r -d '' source; do
    relative=${source#"$source_root"/}
    install_item "$source" "$target_root/$relative"
  done < <(find "$source_root" -type f -print0)
}

install_pinned_tools() {
  local name repository commit directory destination current
  while IFS=$'\t' read -r name repository commit directory; do
    [[ -z $name || $name == \#* ]] && continue
    destination="$TARGET_HOME/$directory"

    if [[ ! -d $destination/.git ]]; then
      echo "==> Cloning $name"
      git clone "$repository" "$destination"
    fi

    current=$(git -C "$destination" rev-parse HEAD)
    if [[ $current != "$commit" ]]; then
      if [[ -n $(git -C "$destination" status --porcelain) ]]; then
        echo "Cannot pin $name: $destination has uncommitted changes." >&2
        exit 1
      fi
      git -C "$destination" fetch origin
      git -C "$destination" checkout --detach "$commit"
    fi

    (
      cd "$destination"
      HOME="$TARGET_HOME" \
      PIPX_HOME="$TARGET_HOME/.local/share/pipx" \
      PIPX_BIN_DIR="$TARGET_HOME/.local/bin" \
      PIPX_MAN_DIR="$TARGET_HOME/.local/share/man" \
        bash install.sh
    )
  done < "$RICE_DIR/packages/tools.tsv"
}

if $INSTALL_PACKAGES; then
  install_packages
fi

echo "==> Restoring configuration files"
install_tree "$RICE_DIR/config" "$TARGET_HOME/.config"
install_tree "$RICE_DIR/local" "$TARGET_HOME/.local"
install_tree "$RICE_DIR/omarchy/themes" "$TARGET_HOME/.config/omarchy/themes"
install_tree "$RICE_DIR/omarchy/backgrounds" "$TARGET_HOME/.config/omarchy/backgrounds"

if $INSTALL_TOOLS; then
  install_pinned_tools
fi

if $APPLY_LIVE; then
  echo "==> Applying desktop state"

  legacy_discord="$TARGET_HOME/.local/share/applications/Discord.desktop"
  if [[ -f $legacy_discord ]] && grep -q '^Exec=.*omarchy-launch-webapp.*discord' "$legacy_discord"; then
    backup_target "$legacy_discord"
    OMARCHY_REMOVE_NOTIFY=false omarchy webapp remove Discord
  fi

  update-desktop-database "$TARGET_HOME/.local/share/applications" 2>/dev/null || true

  if flatpak info com.orcaslicer.OrcaSlicer >/dev/null 2>&1; then
    flatpak override --user --unset-env=GDK_SCALE \
      --env=GDK_DPI_SCALE=0.7 com.orcaslicer.OrcaSlicer
  fi

  # Stop GTK3 Waybar before changing cursor settings; a live cursor reload can
  # crash GTK3 while the pointer crosses the bar.
  pkill -x waybar 2>/dev/null || true
  gsettings set org.gnome.desktop.interface cursor-size 12
  systemctl --user set-environment XCURSOR_SIZE=12 HYPRCURSOR_SIZE=12
  XCURSOR_SIZE=12 HYPRCURSOR_SIZE=12 \
    dbus-update-activation-environment --systemd XCURSOR_SIZE HYPRCURSOR_SIZE

  omarchy theme set tree
  if command -v omarchy-toggle >/dev/null 2>&1; then
    omarchy-toggle bar-off on
  fi

  if hyprctl version >/dev/null 2>&1; then
    hyprctl reload >/dev/null
    hyprctl setcursor default 12 >/dev/null
    config_errors=$(hyprctl configerrors)
    if [[ -n $config_errors ]]; then
      echo "$config_errors" >&2
      exit 1
    fi
  fi

  omarchy restart terminal
  "$TARGET_HOME/.local/bin/omarchy-restart-waybar"
fi

echo
echo "Restore complete."
if [[ -d $BACKUP_DIR ]]; then
  echo "Backup: $BACKUP_DIR"
else
  echo "No existing files needed backup."
fi
echo "Run ./verify.sh to check the restored system."
