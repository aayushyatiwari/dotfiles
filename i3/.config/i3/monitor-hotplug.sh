#!/bin/bash

if xrandr | grep "HDMI-1-0 connected"; then
    xrandr --output eDP-1 --auto --output HDMI-1-0 --auto --left-of eDP-1
else
    xrandr --output eDP-1 --auto --output HDMI-1-0 --off
    i3-msg 'workspace 2, move workspace to output eDP-1'
    i3-msg 'workspace 3, move workspace to output eDP-1'
fi
