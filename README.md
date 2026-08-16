# Dotfiles

Personal [Omarchy](https://omarchy.org/) overlays, managed with [chezmoi](https://www.chezmoi.io/).

Omarchy already ships the desktop. This repo only tracks the Hyprland overrides and helper scripts that differ from stock. The Hyprland bindings assume [hypr-taskspace](https://github.com/jsimonrichard/hypr-taskspace) (`tsk`) is installed.

## What's included

- **Hyprland** (`~/.config/hypr/`) — Omarchy Quattro Lua config
  - Caps Lock as Super, natural scrolling
  - Tighter gaps, master layout
  - Laptop + external monitor layout
  - Keybinding overrides (T3 Chat, [hypr-taskspace](https://github.com/jsimonrichard/hypr-taskspace))
- **window-switcher** (`~/.local/bin/window-switcher`) — pick an open Hyprland window with walker

## New machine

Needs a working Omarchy install and [hypr-taskspace](https://github.com/jsimonrichard/hypr-taskspace), then:

```bash
omarchy pkg add chezmoi
chezmoi init --apply git@github.com:jsimonrichard/dotfiles.git
```

HTTPS alternative:

```bash
chezmoi init --apply https://github.com/jsimonrichard/dotfiles.git
```

Review `~/.config/hypr/monitors.lua` after apply — it is machine-specific.

`window-switcher` expects `hyprctl`, `jq`, and `walker` (all stock on Omarchy).

## Already installed

```bash
chezmoi update   # git pull + apply
chezmoi diff     # preview pending changes
chezmoi apply    # apply without pulling
```

Hyprland reloads on save. If it does not: `hyprctl reload`.
