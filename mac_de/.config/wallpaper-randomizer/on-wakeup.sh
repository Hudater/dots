#!/bin/sh
# sleepwatcher system-wakeup hook: randomize wallpaper on system wake.
# Installed via com.username.sleepwatcher.plist (see README.md).
WALL_DIR=~/syncthing/PC-Walls
export WALL_DIR
~/.config/wallpaper-randomizer/wallpaperRandom.sh >>/tmp/wallpaper-unlock.log 2>&1
