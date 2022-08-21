nitrogen --set-scaled --random /home/putin/GitIt/Wallpapers-PC &
xrandr --output HDMI-A-0 --mode 1920x1080 --rate 144 &
imwheel --button "45" &
numlockx &
redshift &
#picom -b --experimental-backends &
nm-applet &
volumeicon &
#setxkbmap -option caps:swapescape &
#`exec awesome` can't be used for runit so use below command
exec awesome
# exec dbus-run-session awesome
