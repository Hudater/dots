#!/bin/sh

set -e
currentWall="$(find $HOME/GitIt/Wallpapers/pc -type f | shuf -n 1)"

ln -sf $currentWall $HOME/.current_wallpaper
swww img $HOME/.current_wallpaper
