-- Input overrides restored from the pre-Quattro configuration.
hl.config({
  input = {
    kb_layout = "us",
    kb_options = "caps:backspace",
    repeat_rate = 40,
    repeat_delay = 250,
    numlock_by_default = true,

    touchpad = {
      scroll_factor = 0.4,
    },
  },
})

-- App-specific touchpad scroll speeds. These match the old window rules and
-- intentionally live in the user config so future default changes cannot
-- silently remove them.
o.window("(Alacritty|kitty|foot)", { scroll_touchpad = 1.5 })
o.window("com.mitchellh.ghostty", { scroll_touchpad = 0.2 })
