# omarchy-rice

Reproducible Omarchy desktop configurations. The `tree` rice is a complete snapshot of the working Quattro setup, with a from-clean-install bootstrap and an exact file verifier.

## Restore from a clean Omarchy install

```bash
git clone https://github.com/Santa-Claws/omarchy-rice.git
cd omarchy-rice/rices/tree
./install.sh
```

The installer:

- installs required Pacman/AUR packages and Flatpaks;
- installs pinned versions of `hypr-typr` and `omarchy-scaling-tui`;
- backs up every overwritten file;
- restores Hyprland Lua configuration, Waybar, compact half-size notifications, terminal configuration, the Tree theme, wallpaper, application scaling, defaults, helper scripts, and autostart;
- removes Omarchy's duplicate Discord web-app launcher;
- hides Quattro's bar, starts Waybar, applies the theme, and validates Hyprland.

This is a desktop/rice backup, not a disk image. It intentionally excludes credentials, application profiles, browser data, Discord data, caches, VPN identity, and third-party application binaries.

See [rices/tree/README.md](rices/tree/README.md) for the exact contents, recovery options, and verification commands.

## Repository layout

```text
rices/tree/
├── config/             # Restored to ~/.config
├── local/              # Restored to ~/.local
├── omarchy/            # Custom themes and backgrounds
├── packages/           # Pacman, AUR, Flatpak, and pinned Git dependencies
├── install.sh          # Idempotent bootstrap with backups
├── verify.sh           # Exact file and runtime checks
└── snapshot.sh         # Refresh the whitelist from the live desktop
```
