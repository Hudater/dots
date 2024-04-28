#!/bin/sh
# Kill and restart waybar whenever its config files change0
# Credit: https://www.reddit.com/r/hyprland/comments/136gptg/comment/jkie75f/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
CONFIG_FILES="$HOME/.config/waybar/config.jsonc $HOME/.config/waybar/style.css"

trap "killall waybar" EXIT

while true; do
    logger -i "$0: Starting waybar in the background..."
    waybar &
    logger -i "$0: Started waybar PID=$!. Waiting for modifications to ${CONFIG_FILES}..."
    inotifywait -e modify ${CONFIG_FILES} 2>&1 | logger -i
    logger -i "$0: inotifywait returned $?. Killing all waybar processes..."
    killall waybar 2>&1 | logger -i
    logger -i "$0: killall waybar returned $?, wait a sec..."
    sleep 1
done
