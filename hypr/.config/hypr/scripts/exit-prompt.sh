#!/bin/sh
# i3: i3-nagbar -t warning -m 'Exit i3?' -B 'Yes, exit i3' 'i3-msg exit'
choice=$(printf 'No\nYes, exit Hyprland\n' | rofi -dmenu -p 'Exit Hyprland?' -lines 2)
[ "$choice" = "Yes, exit Hyprland" ] && hyprctl dispatch exit
