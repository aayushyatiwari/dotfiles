#!/bin/bash
# Helper script to set wallpaper and sync colors

WALLPAPER="$1"

# If no wallpaper provided, try to find the current one
if [ -z "$WALLPAPER" ]; then
    if [ -L ~/.config/rofi/.current_wallpaper ]; then
        WALLPAPER=$(readlink -f ~/.config/rofi/.current_wallpaper)
    else
        # Fallback to a default if symlink doesn't exist
        WALLPAPER=~/Pictures/1-2-26_bg.jpg
    fi
fi

# Check if file exists
if [ ! -f "$WALLPAPER" ]; then
    echo "Error: File $WALLPAPER not found."
    exit 1
fi

# Set the wallpaper with feh
feh --bg-scale "$WALLPAPER"

# Run wallust to update colors (if installed)
if command -v wallust &> /dev/null; then
    wallust run "$WALLPAPER" > /dev/null 2>&1
fi

# Update the symlink for Rofi background
ln -sf "$WALLPAPER" ~/.config/rofi/.current_wallpaper

# --- RESTART POLYBAR ---
# Consolidate restarting logic here to avoid duplication
killall -q polybar
while pgrep -u $UID -x polybar >/dev/null; do sleep 0.1; done

if xrandr | grep -q "HDMI-1-0 connected"; then
    MONITOR=eDP-1 polybar --reload toph > /dev/null 2>&1 &
    MONITOR=HDMI-1-0 polybar --reload toph-hdmi > /dev/null 2>&1 &
else
    MONITOR=eDP-1 polybar --reload toph > /dev/null 2>&1 &
fi
