#!/bin/sh
# /etc/greetd/start-sway.sh

exec &> ~/.start-sway.log

# Session
export XDG_SESSION_TYPE=wayland
export XDG_SESSION_DESKTOP=sway
export XDG_CURRENT_DESKTOP=sway

# Wayland stuff
export MOZ_ENABLE_WAYLAND=1
export QT_QPA_PLATFORM="wayland;xcb"
export SDL_VIDEODRIVER=wayland
export _JAVA_AWT_WM_NONREPARENTING=1

echo "Starting sway..."

exec systemd-cat --identifier=sway sway

