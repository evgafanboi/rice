#!/bin/bash

# Configuration
WALLPAPER_DIR="$HOME/Pictures/" # Change this to your own directory
INTERVAL=600  # Time in seconds (600 = 10 minutes)

# Function to change wallpaper
change_wallpaper() {
    pkill swaybg
    WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.svg" -o -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) | shuf -n 1)
    swaybg -i "$WALLPAPER" -m fill &
}

# Check if script should run in loop mode
if [[ "$1" == "--loop" ]]; then
    while true; do
        change_wallpaper
        sleep $INTERVAL
    done
else
    change_wallpaper
fi
