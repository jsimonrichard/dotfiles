-- Native Zoom Workplace on Hyprland (XWayland).
-- Auxiliary surfaces (share toolbar, annotate, menus, PiP) must float; tiling
-- them breaks click targets and parks empty transparent chrome in the layout.
-- Main home/meeting windows stay tiled.
--
-- Share controls (as_toolbar / as_preview) advertise as X11 TOOLTIPs. Hyprland
-- then intermittently routes clicks to the window underneath even when
-- allows_input is set. Strip that atom via scripts/zoom-sharing-input.py.

local zoom = "^(zoom|Zoom Workplace)$"
local repair_script = os.getenv("HOME") .. "/.config/hypr/scripts/zoom-sharing-input.py"

-- Default: float Zoom chrome (toolbars, annotate, popups, mini video).
o.window(zoom, {
  float = true,
  no_blur = true,
  no_shadow = true,
})

-- Keep the real app windows in the tiling layout.
o.window({ class = zoom, title = "^(Zoom Workplace( - .*)?|Meeting)$" }, {
  tile = true,
})

-- Share toolbar / preview: force input + pin.
o.window({ class = zoom, title = "^as_(toolbar|preview)$" }, {
  float = true,
  pin = true,
  allows_input = true,
  no_focus = false,
})

-- Annotate tool palette.
o.window({ class = zoom, title = "^annotate_toolbar$" }, {
  float = true,
  pin = true,
  allows_input = true,
})

-- Fullscreen annotation canvas sits above everything and steals clicks from
-- the share bar when left mapped. Keep it from taking focus so the toolbar
-- remains reachable; drawing still works via allows_input.
o.window({ class = zoom, title = "^Annotation - Zoom$" }, {
  float = true,
  no_focus = true,
  allows_input = true,
  no_blur = true,
  no_shadow = true,
})

-- Green share-region frame.
o.window({ title = "^cpt_frame_xcb_window$" }, {
  float = true,
  no_blur = true,
  no_shadow = true,
})

-- Dropdown / context menus need to stay interactive.
o.window({ class = zoom, title = "^(menu window|meeting topbar popup|meeting bottombar popup)$" }, {
  float = true,
  stay_focused = true,
})

local function repair_zoom_sharing_input(window)
  if not window or window.class ~= "zoom" then
    return
  end
  local title = window.title or ""
  if title == "as_toolbar" or title == "as_preview" or title == "Annotation - Zoom" then
    hl.exec_cmd("/usr/bin/python3 " .. o.shell_quote(repair_script))
  end
end

hl.on("window.open", repair_zoom_sharing_input)
hl.on("window.title", repair_zoom_sharing_input)

for _, window in ipairs(hl.get_windows()) do
  repair_zoom_sharing_input(window)
end
