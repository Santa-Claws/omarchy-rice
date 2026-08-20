-- ML4W-style bindings restored from the pre-Quattro configuration.
-- Omarchy defaults remain available unless explicitly replaced below.

-- hypr-typr: type clipboard contents as keystrokes.
o.bind("SUPER + Y", "Type clipboard", "hypr-typr type >/dev/null 2>&1")
o.bind("SUPER + ALT + Y", "Stop typing", "hypr-typr stop >/dev/null 2>&1")

-- Additional application shortcuts.
o.bind("SUPER + B", "Browser", { omarchy = "browser" })
o.bind("SUPER + ALT + B", "Browser (private)", { omarchy = "browser --private" })
o.bind("SUPER + E", "File manager", { omarchy = "nautilus" })

-- Preserve the pre-Quattro Spotify scale override.
hl.unbind("SUPER + SHIFT + M")
o.bind(
  "SUPER + SHIFT + M",
  "Music",
  "omarchy-launch-or-focus spotify \"uwsm-app -- spotify --force-device-scale-factor=0.7\""
)

-- Close window: ML4W SUPER+Q (Omarchy default was SUPER+W).
hl.unbind("SUPER + W")
o.bind("SUPER + Q", "Close window", hl.dsp.window.close())
o.bind("SUPER + SHIFT + Q", "Kill window process", hl.dsp.window.kill())

-- Maximize and float the current workspace. Quattro removed the legacy
-- `workspaceopt allfloat` dispatcher, so keep equivalent state in Lua and
-- apply it to both existing and newly opened windows on that workspace.
o.bind("SUPER + M", "Maximize window", hl.dsp.window.fullscreen({ mode = "maximized" }))

local all_float_workspaces = {}

local function set_window_floating(window, enabled)
  if window and window.floating ~= enabled then
    hl.dispatch(hl.dsp.window.float({
      action = enabled and "on" or "off",
      window = window,
    }))
  end
end

hl.on("window.open", function(window)
  if window.workspace and all_float_workspaces[window.workspace.id] then
    set_window_floating(window, true)
  end
end)

o.bind("SUPER + SHIFT + T", "All windows float", function()
  local workspace = hl.get_active_workspace()
  if not workspace then
    return
  end

  local enabled = not all_float_workspaces[workspace.id]
  all_float_workspaces[workspace.id] = enabled

  for _, window in ipairs(workspace:get_windows()) do
    set_window_floating(window, enabled)
  end
end)

-- Resize with SHIFT+arrows (Omarchy defaults used these for swapping).
hl.unbind("SUPER + SHIFT + LEFT")
hl.unbind("SUPER + SHIFT + RIGHT")
hl.unbind("SUPER + SHIFT + UP")
hl.unbind("SUPER + SHIFT + DOWN")
o.bind("SUPER + SHIFT + RIGHT", "Increase window width", hl.dsp.window.resize({ x = 100, y = 0, relative = true }))
o.bind("SUPER + SHIFT + LEFT", "Decrease window width", hl.dsp.window.resize({ x = -100, y = 0, relative = true }))
o.bind("SUPER + SHIFT + DOWN", "Increase window height", hl.dsp.window.resize({ x = 0, y = 100, relative = true }))
o.bind("SUPER + SHIFT + UP", "Decrease window height", hl.dsp.window.resize({ x = 0, y = -100, relative = true }))

-- Swap with ALT+arrows (Omarchy defaults used these for window groups).
hl.unbind("SUPER + ALT + LEFT")
hl.unbind("SUPER + ALT + RIGHT")
hl.unbind("SUPER + ALT + UP")
hl.unbind("SUPER + ALT + DOWN")
o.bind("SUPER + ALT + LEFT", "Swap window left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + ALT + RIGHT", "Swap window right", hl.dsp.window.swap({ direction = "r" }))
o.bind("SUPER + ALT + UP", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + ALT + DOWN", "Swap window down", hl.dsp.window.swap({ direction = "d" }))

-- Swapsplit: ML4W SUPER+K (Omarchy default was the keybinding viewer).
hl.unbind("SUPER + K")
o.bind("SUPER + K", "Swap split", hl.dsp.layout("swapsplit"))

-- App launcher.
hl.unbind("SUPER + CTRL + RETURN")
o.bind("SUPER + CTRL + RETURN", "Launch apps", "omarchy-menu toggle apps")
o.bind("SUPER + R", "Launch apps", "omarchy-menu toggle apps")

-- Keybinding viewer.
hl.unbind("SUPER + CTRL + K")
o.bind("SUPER + CTRL + K", "Show key bindings", "omarchy-menu-keybindings")

-- Clipboard manager: replaces Quattro's universal-paste binding.
hl.unbind("SUPER + V")
o.bind("SUPER + V", "Clipboard manager", "omarchy-shell shell toggle omarchy.clipboard")

-- Calculator.
hl.unbind("SUPER + CTRL + C")
o.bind("SUPER + CTRL + C", "Calculator", "omacalc")

-- Reload Hyprland.
hl.unbind("SUPER + CTRL + R")
o.bind("SUPER + CTRL + R", "Reload Hyprland config", "hyprctl reload")

-- Screenshot: replaces Quattro's color picker on SUPER+PRINT.
hl.unbind("SUPER + PRINT")
o.bind("SUPER + PRINT", "Screenshot", "omarchy-capture-screenshot")

-- System menu.
hl.unbind("SUPER + CTRL + Q")
o.bind("SUPER + CTRL + Q", "System menu", "omarchy-menu toggle system")

-- Restore the pre-Quattro Waybar toggle.
hl.unbind("SUPER + CTRL + B")
o.bind("SUPER + CTRL + B", "Toggle waybar", "omarchy-toggle-waybar")

-- Theme and background menus.
hl.unbind("SUPER + CTRL + T")
hl.unbind("SUPER + CTRL + W")
o.bind("SUPER + CTRL + T", "Theme menu", "omarchy-menu toggle theme")
o.bind("SUPER + CTRL + W", "Background menu", "omarchy-menu toggle background")

-- Reset display zoom.
o.bind("SUPER + SHIFT + Z", "Reset zoom", function()
  hl.config({ cursor = { zoom_factor = 1 } })
end)

-- Lock and workspace layout.
hl.unbind("SUPER + L")
o.bind("SUPER + L", "Lock system", "omarchy-system-lock")
o.bind("SUPER + SHIFT + L", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")
