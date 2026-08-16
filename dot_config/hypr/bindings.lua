hl.unbind("SUPER + SHIFT + A")
o.bind("SUPER + SHIFT + A", "T3 Chat", 'omarchy-launch-webapp "https://t3.chat"')

-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")


-- Packaged omarchy.lua still binds SUPER+Tab to `tsk task tui-launch`.
-- Unbind that and toggle the overlay until /usr/share/tsk is refreshed.
hl.unbind("SUPER + TAB")
o.bind("SUPER + TAB", "Task manager", "omarchy-shell shell toggle tsk.taskspace")

-- tsk-managed begin
dofile("/usr/share/tsk/hypr/omarchy.lua")
hl.unbind("SUPER + TAB")
o.bind("SUPER + TAB", "Task manager", "/usr/bin/tsk task tui-launch")
-- tsk-managed end
