#!/usr/bin/env bash

# Extracted parts from wallpaperSelect.sh

# Wallpapers Path
wallpaperDir="$WALL_DIR"
themesDir="$HOME/.config/rofi/themes"

# Transition config
FPS=60
TYPE="any"
DURATION=0
BEZIER="0.4,0.2,0.4,1.0"
SWWW_PARAMS="--transition-fps ${FPS} --transition-type ${TYPE} --transition-duration ${DURATION} --transition-bezier ${BEZIER}"

# Check if swaybg is running
if pidof swaybg > /dev/null; then
    pkill swaybg
fi

# Retrieve image files as a list
PICS=($(find "${wallpaperDir}" -type f \( -iname \*.jpg -o -iname \*.jpeg -o -iname \*.png -o -iname \*.gif \) | sort ))

# Use date variable to increase randomness
randomNumber=$(( ($(date +%s) + RANDOM) + $$ ))
randomPicture="${PICS[$(( randomNumber % ${#PICS[@]} ))]}"

# Execute command according the wallpaper manager
executeCommand() {

    if command -v swww &>/dev/null; then
        swww img "$1" ${SWWW_PARAMS}

    elif command -v swaybg &>/dev/null; then
        swaybg -i "$1" &

    else
        echo "Neither swww nor swaybg are installed."
        exit 1
    fi

    ln -sf "$1" "$HOME/.current_wallpaper"
}


# If swww exists, start it
if command -v swww &>/dev/null; then
    swww query || swww-daemon
fi

executeCommand "${randomPicture}"