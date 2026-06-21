#!/usr/bin/env python3
"""
shotpop.py - Mac-style screenshot thumbnail popup for Hyprland/Wayland
Usage: shotpop.py <path-to-screenshot.png>

Features:
- Bottom-right corner overlay (gtk-layer-shell, never steals focus)
- Auto-dismiss after 5s (pauses on hover)
- Click thumbnail = open in swappy
- Copy button = wl-copy to clipboard
- Drag thumbnail = GTK DnD with text/uri-list (works in Discord, browsers, file managers)
"""

import sys
import os
import subprocess
import threading
import gi

gi.require_version("Gtk", "3.0")
gi.require_version("GtkLayerShell", "0.1")
from gi.repository import Gtk, GLib, GdkPixbuf, Gdk, GtkLayerShell

POPUP_WIDTH  = 220
POPUP_HEIGHT = 140
THUMB_WIDTH  = 180
THUMB_HEIGHT = 100
AUTO_DISMISS_SEC = 5
MARGIN = 16


class ShotPop(Gtk.Window):
    def __init__(self, img_path: str):
        super().__init__(type=Gtk.WindowType.TOPLEVEL)
        self.img_path = os.path.abspath(img_path)
        self._timer_id = None
        self._remaining = AUTO_DISMISS_SEC
        self._hovered = False

        self._setup_layer_shell()
        self._build_ui()
        self._start_timer()

        # Auto-copy to clipboard
        self._do_copy()

    # ------------------------------------------------------------------ #
    # Layer shell setup - anchors to bottom-right, never takes focus
    # ------------------------------------------------------------------ #
    def _setup_layer_shell(self):
        GtkLayerShell.init_for_window(self)
        GtkLayerShell.set_layer(self, GtkLayerShell.Layer.OVERLAY)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.BOTTOM, True)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.RIGHT, True)
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.BOTTOM, MARGIN)
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.RIGHT, MARGIN)
        GtkLayerShell.set_keyboard_mode(self, GtkLayerShell.KeyboardMode.NONE)
        # Don't steal focus from whatever the user is doing
        self.set_accept_focus(False)

    # ------------------------------------------------------------------ #
    # UI
    # ------------------------------------------------------------------ #
    def _build_ui(self):
        self.set_size_request(POPUP_WIDTH, POPUP_HEIGHT)
        self.set_decorated(False)
        self.set_app_paintable(True)

        # Rounded corners via CSS
        css = b"""
        window {
            background-color: rgba(30, 30, 30, 0.92);
            border-radius: 12px;
            border: 1px solid rgba(255,255,255,0.12);
        }
        button.copy-btn {
            background: rgba(255,255,255,0.15);
            border: none;
            border-radius: 6px;
            color: white;
            font-size: 11px;
            padding: 3px 10px;
            min-height: 0;
        }
        button.copy-btn:hover {
            background: rgba(255,255,255,0.28);
        }
        label.timer {
            color: rgba(255,255,255,0.45);
            font-size: 10px;
        }
        """
        provider = Gtk.CssProvider()
        provider.load_from_data(css)
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(),
            provider,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION,
        )

        # Enable alpha channel
        screen = self.get_screen()
        visual = screen.get_rgba_visual()
        if visual:
            self.set_visual(visual)

        outer = Gtk.Box(orientation=Gtk.Orientation.VERTICAL, spacing=6)
        outer.set_margin_top(8)
        outer.set_margin_bottom(8)
        outer.set_margin_start(10)
        outer.set_margin_end(10)
        self.add(outer)

        # --- Thumbnail (drag source + click to open swappy) ---
        thumb_box = Gtk.EventBox()
        thumb_box.set_tooltip_text("Click to open in swappy")
        thumb_pixbuf = self._load_thumb()
        thumb_img = Gtk.Image.new_from_pixbuf(thumb_pixbuf)
        thumb_img.set_size_request(THUMB_WIDTH, THUMB_HEIGHT)
        thumb_box.add(thumb_img)

        # Click handler
        thumb_box.connect("button-release-event", self._on_thumb_click)

        # DnD source: expose as text/uri-list so Discord/browsers/etc can accept
        thumb_box.drag_source_set(
            Gdk.ModifierType.BUTTON1_MASK,
            [Gtk.TargetEntry.new("text/uri-list", 0, 0)],
            Gdk.DragAction.COPY,
        )
        thumb_box.connect("drag-data-get", self._on_drag_data_get)
        thumb_box.connect("drag-begin", self._on_drag_begin)

        outer.pack_start(thumb_box, True, True, 0)

        # --- Bottom row: Copy button + timer label ---
        bottom = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=0)

        copy_btn = Gtk.Button(label="Copy")
        copy_btn.get_style_context().add_class("copy-btn")
        copy_btn.connect("clicked", self._on_copy)
        bottom.pack_start(copy_btn, False, False, 0)

        self.timer_label = Gtk.Label(label=f"  closing in {self._remaining}s")
        self.timer_label.get_style_context().add_class("timer")
        bottom.pack_end(self.timer_label, False, False, 0)

        outer.pack_start(bottom, False, False, 0)

        # Hover tracking to pause auto-dismiss
        self.connect("enter-notify-event", self._on_enter)
        self.connect("leave-notify-event", self._on_leave)

        self.show_all()

    def _load_thumb(self) -> GdkPixbuf.Pixbuf:
        try:
            pb = GdkPixbuf.Pixbuf.new_from_file_at_scale(
                self.img_path, THUMB_WIDTH, THUMB_HEIGHT, True
            )
            return pb
        except Exception:
            # Fallback: grey placeholder
            pb = GdkPixbuf.Pixbuf.new(GdkPixbuf.Colorspace.RGB, False, 8, THUMB_WIDTH, THUMB_HEIGHT)
            pb.fill(0x888888FF)
            return pb

    # ------------------------------------------------------------------ #
    # Handlers
    # ------------------------------------------------------------------ #
    def _on_thumb_click(self, widget, event):
        if event.button == 1:
            self._cancel_timer()
            subprocess.Popen(["swappy", "-f", self.img_path])
            self.destroy()

    def _do_copy(self):
        try:
            with open(self.img_path, "rb") as f:
                data = f.read()
            proc = subprocess.Popen(
                ["wl-copy", "--type", "image/png"],
                stdin=subprocess.PIPE,
            )
            proc.communicate(input=data)
        except Exception as e:
            print(f"Copy failed: {e}", file=sys.stderr)

    def _on_copy(self, btn):
        self._do_copy()
        btn.set_label("Copied!")
        GLib.timeout_add(800, lambda: btn.set_label("Copy") or False)

    def _on_drag_data_get(self, widget, drag_context, data, info, time):
        uri = f"file://{self.img_path}"
        data.set_uris([uri])

    def _on_drag_begin(self, widget, drag_context):
        # Show thumbnail as drag icon
        try:
            pb = GdkPixbuf.Pixbuf.new_from_file_at_scale(self.img_path, 120, 80, True)
            Gtk.drag_set_icon_pixbuf(drag_context, pb, 0, 0)
        except Exception:
            pass

    def _on_enter(self, *_):
        self._hovered = True

    def _on_leave(self, *_):
        self._hovered = False

    # ------------------------------------------------------------------ #
    # Auto-dismiss timer
    # ------------------------------------------------------------------ #
    def _start_timer(self):
        self._timer_id = GLib.timeout_add(1000, self._tick)

    def _tick(self):
        if self._hovered:
            # Don't count down while hovered
            return True
        self._remaining -= 1
        if self._remaining <= 0:
            self.destroy()
            return False
        self.timer_label.set_text(f"  closing in {self._remaining}s")
        return True

    def _cancel_timer(self):
        if self._timer_id is not None:
            GLib.source_remove(self._timer_id)
            self._timer_id = None


def main():
    if len(sys.argv) < 2:
        print("Usage: shotpop.py <image.png>", file=sys.stderr)
        sys.exit(1)

    img_path = sys.argv[1]
    if not os.path.isfile(img_path):
        print(f"File not found: {img_path}", file=sys.stderr)
        sys.exit(1)

    app = ShotPop(img_path)
    app.connect("destroy", Gtk.main_quit)
    Gtk.main()


if __name__ == "__main__":
    main()
