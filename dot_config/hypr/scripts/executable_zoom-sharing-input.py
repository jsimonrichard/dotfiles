#!/usr/bin/python3
"""Remove Zoom's TOOLTIP hint from interactive sharing controls.

Hyprland routes override-redirect X11 TOOLTIP windows past allows_input in
some hit-test paths, so clicks land on whatever was focused underneath.
Replace TOOLTIP with NORMAL on as_toolbar / as_preview (and empty-named
Zoom tooltip surfaces that share the same bug).
Requires Arch package python-xlib; must run under /usr/bin/python3.
"""
from __future__ import annotations

import subprocess
import sys

from Xlib import X, Xatom, display, error

CONTROL_TITLES = {"as_toolbar", "as_preview", "annotate_toolbar"}


def window_name(window, connection) -> str:
    name = window.get_wm_name()
    if name:
        return name if isinstance(name, str) else name.decode("utf-8", "replace")
    net = connection.intern_atom("_NET_WM_NAME")
    utf8 = connection.intern_atom("UTF8_STRING")
    prop = window.get_full_property(net, utf8)
    if prop and prop.value:
        raw = prop.value
        if isinstance(raw, bytes):
            return raw.decode("utf-8", "replace")
        return str(raw)
    return ""


def walk(window):
    yield window
    try:
        for child in window.query_tree().children:
            yield from walk(child)
    except error.BadWindow:
        return


def strip_tooltip_hints() -> int:
    connection = display.Display()
    fixed = 0
    try:
        type_atom = connection.intern_atom("_NET_WM_WINDOW_TYPE")
        tooltip = connection.intern_atom("_NET_WM_WINDOW_TYPE_TOOLTIP")
        normal = connection.intern_atom("_NET_WM_WINDOW_TYPE_NORMAL")
        for window in walk(connection.screen().root):
            try:
                if window.get_wm_class() != ("zoom", "zoom"):
                    continue
                prop = window.get_full_property(type_atom, Xatom.ATOM)
                if prop is None or tooltip not in prop.value:
                    continue
                name = window_name(window, connection)
                if name not in CONTROL_TITLES and name != "":
                    continue
                types = [atom for atom in prop.value if atom != tooltip]
                if normal not in types:
                    types.append(normal)
                window.change_property(
                    type_atom,
                    Xatom.ATOM,
                    32,
                    types,
                    mode=X.PropModeReplace,
                )
                fixed += 1
            except error.BadWindow:
                continue
        connection.sync()
    finally:
        connection.close()
    return fixed


def raise_controls() -> None:
    """Keep share controls above the fullscreen Annotation overlay."""
    try:
        import json

        windows = json.loads(subprocess.check_output(["hyprctl", "-j", "clients"]))
    except (OSError, ValueError):
        return
    for w in windows:
        if w.get("class") != "zoom" or w.get("title") not in CONTROL_TITLES:
            continue
        if not w.get("mapped"):
            continue
        addr = w["address"]
        subprocess.run(
            ["hyprctl", "dispatch", "alterzorder", "top", f"address:{addr}"],
            check=False,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )


def main() -> int:
    fixed = strip_tooltip_hints()
    raise_controls()
    print(f"zoom-sharing-input: stripped TOOLTIP on {fixed} window(s)", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
