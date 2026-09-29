#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

# Set explicit session types for i3 and X11
export XDG_SESSION_TYPE=x11
export XDG_CURRENT_DESKTOP=i3
export QT_QPA_PLATFORM=xcb

exec dbus-run-session i3
