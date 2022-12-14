if test (tty) = "/dev/tty1"
  set -Ux SDL_VIDEODRIVER wayland
  set -Ux _JAVA_AWT_WM_NONREPARENTING 1
  set -Ux QT_QPA_PLATFORM "wayland;xcb"
  set -Ux XDG_CURRENT_DESKTOP sway
  set -Ux XDG_SESSION_DESKTOP sway
  sway || true
  logout
end
