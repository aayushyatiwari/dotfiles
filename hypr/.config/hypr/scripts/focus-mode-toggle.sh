#!/bin/sh
# i3's `focus mode_toggle`: jump focus between the tiling and the floating layer.
# Hyprland has no dispatcher for this, so ask which layer we are on and hop.
if [ "$(hyprctl activewindow -j | jq -r '.floating')" = "true" ]; then
    hyprctl dispatch cyclenext tiled
else
    hyprctl dispatch cyclenext floating
fi
