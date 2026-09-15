#!/bin/sh
# sleepwatcher display-wakeup hook: randomize wallpaper on screen off/on.
# Installed via com.username.sleepwatcher.plist (see README.md).
WALL_DIR=~/syncthing/PC-Walls
export WALL_DIR
~/.config/wallpaper-randomizer/wallpaperRandom.sh >>/tmp/wallpaper-unlock.log 2>&1
