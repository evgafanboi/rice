#!/bin/bash

# Nordic color palette
BACKGROUND="#2E3440"
FOREGROUND="#D8DEE9"
SELECTED="#5E81AC"
ACCENT="#88C0D0"

entries="⇠  Logout\n⭮  Reboot\n⏻  Shutdown\n  Lock"

selected=$(echo -e $entries | wofi \
    --dmenu \
    --cache-file /dev/null \
    --prompt "Power Menu" \
    --width 250 \
    --height 250 \
    --style ~/.config/waybar/power-menu.css \
    | awk '{print tolower($2)}')

case $selected in
    logout)
        swaymsg exit;;
    reboot)
        exec systemctl reboot;;
    shutdown)
        exec systemctl poweroff -i;;
    lock)
        exec swaylock;;
esac
