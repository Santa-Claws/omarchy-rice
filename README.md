# omarchy-rice

A collection of rices for [Omarchy](https://omarchy.com) — the opinionated Hyprland setup.

## Rices

| Rice | Preview | Description |
|---|---|---|
| [tree](rices/tree/) | ![tree](rices/tree/preview.png) | Monochrome dark charcoal, 85% opacity terminals, ML4W keybindings |

## Installing a rice

Each rice has its own `install.sh` that backs up your existing files before applying:

```bash
git clone https://github.com/Santa-Claws/omarchy-rice.git
cd omarchy-rice/rices/<rice-name>
chmod +x install.sh
./install.sh
```

Requires [Omarchy](https://omarchy.com) to already be installed.

## Adding a rice

1. Fork this repo
2. Create `rices/<your-rice-name>/` following the structure below
3. Add a `preview.png`, `README.md`, and `install.sh`
4. Open a PR

### Rice structure

```
rices/<name>/
├── README.md                  # Description + keybindings table
├── preview.png                # Screenshot for the table above
├── install.sh                 # Installer with backup logic
├── config/
│   ├── hypr/                  # ~/.config/hypr/ overrides
│   ├── waybar/                # ~/.config/waybar/ overrides
│   ├── mimeapps.list          # Default apps
│   └── xdg-terminals.list    # Terminal preference
├── local/
│   └── share/
│       └── applications/      # ~/.local/share/applications/ overrides
└── omarchy/
    ├── themes/<name>/         # ~/.config/omarchy/themes/<name>/
    └── backgrounds/           # ~/.config/omarchy/backgrounds/ (merged)
```

The `install.sh` should back up any files it overwrites and call `omarchy-theme-set <name>` + `hyprctl reload` at the end.
