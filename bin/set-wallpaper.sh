#!/bin/bash
# Set the wallpaper with feh
feh --bg-scale "$1"

# Run wallust to update colors (if installed)
if command -v wallust &> /dev/null; then
    wallust run "$1"
else
    echo "Warning: wallust not found, skipping color sync."
fi

# Update the symlink for Rofi background
ln -sf "$1" ~/.config/rofi/.current_wallpaper

# Restart Polybar to pick up new colors
~/.config/polybar/launch.sh
