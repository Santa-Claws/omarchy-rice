-- Workspace autostart restored from the pre-Quattro configuration.
hl.on("hyprland.start", function()
  hl.exec_cmd("uwsm-app -- waybar")
  hl.exec_cmd("uwsm-app -- firefox", { workspace = "1 silent" })
  hl.exec_cmd("uwsm-app -- xdg-terminal-exec", { workspace = "2 silent" })
  hl.exec_cmd("uwsm-app -- xdg-terminal-exec", { workspace = "2 silent" })
  hl.exec_cmd(
    "flatpak run com.discordapp.Discord --force-device-scale-factor=0.7",
    { workspace = "3 silent" }
  )
  hl.exec_cmd("omarchy-scaling-tui --apply-discord-zoom 0.7")
  hl.exec_cmd(
    "uwsm-app -- env XCURSOR_SIZE=6 HYPRCURSOR_SIZE=6 spotify --force-device-scale-factor=0.7",
    { workspace = "4 silent" }
  )
end)
