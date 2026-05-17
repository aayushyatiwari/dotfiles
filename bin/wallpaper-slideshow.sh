#!/bin/bash
# Simple Wallpaper Slideshow Script

# Folder containing your wallpapers
WALLPAPER_DIR="$HOME/Pictures/wallpapers"

# Interval in seconds (e.g., 300 for 5 minutes)
INTERVAL=10

# Check if the folder exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    echo "Directory $WALLPAPER_DIR not found. Please create it or update the script."
    exit 1
fi

while true; do
    # Pick a random image file from the folder
    # This looks for .jpg, .png, .jpeg, and .webp files
    WALLPAPER=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.webp" \) | shuf -n 1)

    if [ -n "$WALLPAPER" ]; then
        # Use feh to set the background
        feh --bg-scale "$WALLPAPER"

        # Update the symlink so Rofi can use the current background
        ln -sf "$WALLPAPER" ~/.config/rofi/.current_wallpaper
    fi

    # Wait for the next change
    sleep $INTERVAL
done
