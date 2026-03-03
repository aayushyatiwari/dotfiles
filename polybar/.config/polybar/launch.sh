#!/bin/bash

killall -q polybar

while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

if type "xrandr"; then
  MONITOR=eDP-1 polybar --reload toph &
else
  polybar --reload toph &
fi
