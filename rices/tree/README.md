# tree

![preview](preview.png)

A minimal monochrome rice for [Omarchy](https://omarchy.com). Dark charcoal terminals at 85% opacity over a tree wallpaper. ML4W-style keybindings adapted for Omarchy.

## What's included

| Component | Detail |
|---|---|
| **Theme** | Dark charcoal (`#252525`) + off-white (`#e8e8e8`), grayscale ANSI palette |
| **Opacity** | Active 85%, inactive 80% — wallpaper visible behind windows |
| **Wallpaper** | Tree (also added to the tokyo-night background pool) |
| **Keybindings** | ML4W layout — see table below |
| **Autostart** | Firefox ws1, 2× terminal ws2, Discord ws3, Spotify ws4 |
| **Input** | CapsLock → Backspace, touchpad scroll factor 0.4 |
| **Clock** | 12-hour AM/PM |
| **Apps** | Discord (flatpak) + Spotify at 70% scale factor |
| **Browser** | Firefox as default |
| **Terminal** | Alacritty preferred (`xdg-terminals.list`) |

## Keybindings (ML4W layout)

| Key | Action |
|---|---|
| `Super + Return` | Terminal |
| `Super + Alt + Return` | Terminal (tmux) |
| `Super + B` | Browser |
| `Super + E` | File manager |
| `Super + Q` | Close window |
| `Super + M` | Maximize |
| `Super + K` | Swap split |
| `Super + L` | Lock screen |
| `Super + R` | App launcher |
| `Super + V` | Clipboard |
| `Super + Shift + M` | Spotify |
| `Super + Shift + N` | Editor |
| `Super + Shift + D` | Docker (lazydocker) |
| `Super + Shift + G` | Signal |
| `Super + Shift + O` | Obsidian |
| `Super + Shift + /` | 1Password |
| `Super + Shift + arrows` | Resize window |
| `Super + Alt + arrows` | Swap window |
| `Super + Ctrl + Return` | App launcher |
| `Super + Ctrl + K` | Show keybindings |
| `Super + Ctrl + T` | Theme menu |
| `Super + Ctrl + W` | Wallpaper menu |
| `Super + Ctrl + R` | Reload Hyprland |
| `Super + Ctrl + Q` | System menu |
| `Super + Ctrl + L` | Lock screen |
| `Super + Ctrl + B` | Toggle waybar |
| `Super + Shift + L` | Toggle workspace layout |
| `Super + Print` | Screenshot |

## Install

```bash
git clone https://github.com/Santa-Claws/omarchy-rice.git
cd omarchy-rice/rices/tree
chmod +x install.sh
./install.sh
```

Requires [Omarchy](https://omarchy.com) to be installed first.
