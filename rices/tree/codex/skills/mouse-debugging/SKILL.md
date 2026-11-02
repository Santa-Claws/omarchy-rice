---
name: mouse-debugging
description: Diagnose and fix Linux mouse-pointer size, theme, hotspot, or rendering regressions, especially differences between Hyprland/Wayland, XWayland, Chromium, Electron, Flatpak, and app-launcher paths. Use for reports such as "cursor is huge in Chrome", "only this app has a tiny/big mouse", cursor changes after restart or scaling changes, or when a reliable visual cursor test is needed.
---

# Mouse Debugging

Diagnose the application path before changing global cursor settings. Preserve the user's normal Hyprland cursor when the fault is isolated to one application.

## Triage

1. Identify the affected client with `hyprctl clients -j`; record `class`, `pid`, `xwayland`, `at`, and `size`.
2. Inspect the actual launcher and any wrapper used by the app menu. Do not assume a shell-launched app uses the same environment.
3. Record the cursor inputs:

   ```bash
   gsettings get org.gnome.desktop.interface cursor-theme
   gsettings get org.gnome.desktop.interface cursor-size
   xrdb -query | rg -i cursor
   systemctl --user show-environment | rg 'XCURSOR|HYPRCURSOR'
   ```

4. Compare a fresh isolated launch before editing a real user profile. For Chromium also record the active `chromium-flags.conf` and whether it is forced to X11 or Wayland.

## Chromium/X11 Cursor Fix

Chromium's X11 cursor loader can use the GTK/Xresources cursor theme name rather than `XCURSOR_THEME`. A private `XCURSOR_PATH` must therefore include a compact theme directory named for every applicable lookup name (commonly `default`, `Adwaita`, and the theme from `xrdb`, such as `Adwaita-6`).

Use a per-app wrapper instead of shrinking the global cursor:

```bash
export XCURSOR_PATH="$HOME/.local/share/chromium-cursor:$HOME/.local/share/icons:$HOME/.icons:/usr/share/icons:/usr/share/pixmaps:/usr/X11R6/lib/X11/icons"
export XCURSOR_SIZE=12
exec /usr/bin/chromium "$@"
```

Put complete compact cursor files in each private theme's `cursors/` directory. Point every desktop-entry `Exec=` and action to the wrapper. Keep existing Chromium scaling flags intact unless the task explicitly changes scaling.

Do not depend on a browser extension for this: extensions only affect webpage cursors, not Chromium's tab strip, menus, settings, or titlebar.

## Visual Verification

Prefer the established local test when it exists:

```bash
~/.local/bin/test-chromium-cursor
```

It starts isolated Chromium profiles, confirms XWayland plus device-scale factor `0.70`, moves a real virtual pointer, captures baseline/cursor images, and rejects oversized cursor bounding boxes. It restores focus and pointer position and does not touch the user's profile.

If the test needs repair, use the local `/dev/uinput` relative-pointer helper rather than trusting `ydotool`; on this system `ydotool` can connect successfully while emitting no usable pointer events. Verify pointer movement with `hyprctl cursorpos -j` before treating screenshot differences as evidence.

Also launch once through the real app-menu path (`uwsm-app -- chromium`) and confirm the resulting client is XWayland when X11 scaling is expected. Close only the test window and restore focus.

## Guardrails

- Do not modify `/usr/share/omarchy`.
- Do not use global cursor size/theme changes to mask an app-specific issue.
- Do not close unrelated application windows or switch the user's workspace.
- Validate rendering after every change; a process exit code alone is not proof.
- When the change belongs in the rice, run its snapshot script, review `git diff --check`, commit, and push.
