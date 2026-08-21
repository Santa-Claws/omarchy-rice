# Tree rice

![Tree rice preview](preview.png)

A monochrome charcoal Omarchy Quattro setup restored from the live desktop on August 20, 2026. It uses the Tree wallpaper, translucent windows, ML4W-style bindings, a compact 26px Waybar, 2× display scaling, half-size cursor, and 0.7 overrides for selected applications.

## What is backed up

| Component | Restored state |
|---|---|
| Theme | Tree, `#252525` background, `#e8e8e8` foreground |
| Windows | 85% active opacity, 80% inactive opacity, gray active border |
| Display | Preferred mode at scale 2, `GDK_SCALE=2` |
| Cursor | Size 12 (half of Omarchy's default 24) |
| Input | Caps Lock → Backspace, repeat 40/250ms, touchpad scroll 0.4 |
| Terminal | Alacritty preferred, JetBrains Mono Nerd Font at 6.5; matching Foot/Kitty/Ghostty configs |
| Waybar | Exact 26px layout, 12-hour clock, weather, tray drawer, VPN, home-network and idle status |
| Notifications | All notification cards at 50% width, height, typography, icon, and padding |
| Codex completion | Success/failure desktop notification without terminal urgency or workspace switching; brief Git commit handoff |
| Autostart | Waybar; Firefox ws1; two terminals ws2; Discord ws3; Spotify ws4 |
| Scaling | Discord (launcher, wrapper, and effective 70% UI zoom on autostart), Spotify, Chromium and Betaflight at 0.7; OrcaSlicer `GDK_DPI_SCALE=0.7` |
| Defaults | Firefox browser, Alacritty terminal, existing MIME preferences |
| Helpers | Waybar toggle/restart scripts, `hypr-typr`, Quattro-compatible indicator scripts |

Waybar's home-network widget includes the original private LAN hosts `thelittleone` (`192.168.254.161`) and `nestlecrunch` (`192.168.254.84`). Edit `config/waybar/scripts/home-network.sh` before installing elsewhere if those names or addresses differ.

## Restore from a clean install

Start with a working Omarchy Quattro installation and network access:

```bash
git clone https://github.com/Santa-Claws/omarchy-rice.git
cd omarchy-rice/rices/tree
./install.sh
```

The normal installer is idempotent and prompts before making changes. Use `./install.sh --yes` for an unattended restore. Existing files are backed up under `~/.local/state/omarchy-rice/backups/` before replacement.

Useful options:

```text
--skip-packages   Restore files without installing packages or Flatpaks
--skip-tools      Do not clone/install the pinned helper repositories
--no-apply        Copy files but do not change the live desktop session
--target-home DIR Restore into another home directory (implies all three above)
```

After a successful clean restore, authenticate Tailscale and WARP if wanted; their device identities are deliberately not stored in Git.

## Verify the backup

```bash
./verify.sh
```

This compares every bundled file with the live target and checks packages, Flatpaks, theme, cursor, scaling, Hyprland errors, Waybar, and the hidden Quattro bar.

For a safe from-empty-directory test:

```bash
target=$(mktemp -d)
./install.sh --yes --target-home "$target"
./verify.sh --files-only --target-home "$target"
```

## Refresh this backup later

```bash
./snapshot.sh
git diff --check
git status --short
```

The snapshot script copies only the explicit rice whitelist. It does not collect browser profiles, credentials, VPN state, caches, SSH material, or unrelated application data.
