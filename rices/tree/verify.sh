#!/usr/bin/env bash
set -u

RICE_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
TARGET_HOME=${RICE_TARGET_HOME:-$HOME}
FILES_ONLY=false
FAILURES=0

usage() {
  echo "Usage: ./verify.sh [--files-only] [--target-home DIR]"
}

while (($#)); do
  case $1 in
    --files-only)
      FILES_ONLY=true
      ;;
    --target-home)
      [[ $# -ge 2 ]] || { usage >&2; exit 2; }
      TARGET_HOME=$2
      shift
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

pass() { printf 'PASS  %s\n' "$1"; }
fail() { printf 'FAIL  %s\n' "$1"; FAILURES=$((FAILURES + 1)); }

compare_tree() {
  local source_root=$1 target_root=$2 source relative target
  while IFS= read -r -d '' source; do
    relative=${source#"$source_root"/}
    target="$target_root/$relative"
    if [[ ! -f $target ]]; then
      fail "missing $target"
    elif ! cmp -s -- "$source" "$target"; then
      fail "different $target"
    elif [[ -x $source && ! -x $target ]]; then
      fail "not executable $target"
    fi
  done < <(find "$source_root" -type f -print0)
}

compare_tree "$RICE_DIR/codex" "$TARGET_HOME/.codex"
compare_tree "$RICE_DIR/config" "$TARGET_HOME/.config"
compare_tree "$RICE_DIR/local" "$TARGET_HOME/.local"
compare_tree "$RICE_DIR/var" "$TARGET_HOME/.var"
compare_tree "$RICE_DIR/omarchy/themes" "$TARGET_HOME/.config/omarchy/themes"
compare_tree "$RICE_DIR/omarchy/backgrounds" "$TARGET_HOME/.config/omarchy/backgrounds"

if ((FAILURES == 0)); then
  pass "all bundled files match $TARGET_HOME"
fi

if ! $FILES_ONLY; then
  while IFS= read -r package; do
    [[ -z $package || $package == \#* ]] && continue
    pacman -Q "$package" >/dev/null 2>&1 \
      && pass "package $package" \
      || fail "package $package is missing"
  done < <(sed -e '/^[[:space:]]*#/d' -e '/^[[:space:]]*$/d' \
    "$RICE_DIR/packages/pacman.txt" "$RICE_DIR/packages/aur.txt")

  while IFS= read -r app_id; do
    [[ -z $app_id || $app_id == \#* ]] && continue
    flatpak info "$app_id" >/dev/null 2>&1 \
      && pass "Flatpak $app_id" \
      || fail "Flatpak $app_id is missing"
  done < "$RICE_DIR/packages/flatpak.txt"

  [[ $(gsettings get org.gnome.desktop.interface cursor-size 2>/dev/null) == 12 ]] \
    && pass "GTK cursor size is 12" \
    || fail "GTK cursor size is not 12"

  [[ -f $TARGET_HOME/.local/state/omarchy/toggles/bar-off ]] \
    && pass "Quattro bar is disabled" \
    || fail "Quattro bar disable flag is missing"

  pgrep -x waybar >/dev/null 2>&1 \
    && pass "Waybar is running" \
    || fail "Waybar is not running"

  if flatpak override --user --show com.orcaslicer.OrcaSlicer 2>/dev/null \
      | grep -q '^GDK_DPI_SCALE=0.7$'; then
    pass "OrcaSlicer scale is 0.7"
  else
    fail "OrcaSlicer scale is not 0.7"
  fi

  if grep -qx -- '--force-device-scale-factor=0.7' \
      "$TARGET_HOME/.var/app/com.discordapp.Discord/config/discord-flags.conf" 2>/dev/null; then
    pass "Discord wrapper scale is 0.7"
  else
    fail "Discord wrapper scale is not 0.7"
  fi

  if grep -qx -- '--force-device-scale-factor=0.7' \
      "$TARGET_HOME/.config/chromium-flags.conf" 2>/dev/null \
      && grep -q '^Exec=/usr/bin/chromium --force-device-scale-factor=0.7 ' \
        "$TARGET_HOME/.local/share/applications/chromium.desktop" 2>/dev/null; then
    pass "Chromium scale is 0.7 on every launch path"
  else
    fail "Chromium scale is not 0.7 on every launch path"
  fi

  if hyprctl version >/dev/null 2>&1; then
    config_errors=$(hyprctl configerrors)
    [[ -z $config_errors ]] \
      && pass "Hyprland configuration has no errors" \
      || fail "Hyprland configuration errors: $config_errors"

    if hyprctl getoption misc:focus_on_activate 2>/dev/null | grep -q '^bool: false$'; then
      pass "application activation cannot steal focus"
    else
      fail "application activation can steal focus"
    fi
  fi

  [[ $(omarchy theme current 2>/dev/null | tr '[:upper:]' '[:lower:]') == tree ]] \
    && pass "Tree theme is active" \
    || fail "Tree theme is not active"
fi

echo
if ((FAILURES)); then
  echo "$FAILURES verification check(s) failed."
  exit 1
fi

echo "Everything verified."
