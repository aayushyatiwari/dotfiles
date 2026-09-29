#!/bin/sh
# Replaces `flameshot gui`, whose interactive region select does not work on Wayland.
# No argument -> select a region. Argument "full" -> whole output.
# Either way: copied to the clipboard and saved under ~/Pictures/Screenshots.
set -e
dir="$HOME/Pictures/Screenshots"
mkdir -p "$dir"
file="$dir/$(date +%Y-%m-%d_%H-%M-%S).png"

if [ "$1" = "full" ]; then
    grim "$file"
else
    region=$(slurp) || exit 0
    grim -g "$region" "$file"
fi

wl-copy < "$file"
notify-send "Screenshot" "Copied, saved to $file"
