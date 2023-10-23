imwheel --button "45" &
numlockx &
redshift &
#picom -b --experimental-backends &
nm-applet &
volumeicon &
xfce4-power-manager &
#cbatticon -r 20 -l 80 &
#setxkbmap -option caps:swapescape &
#xrandr --output HDMI-1 --mode 1920x1080 --rate 144 &
### Install `polkit-gnome` first
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
#xrandr --output eDP-1 --off --output HDMI-1 --mode 1920x1080 --rate 120 --pos 0x0 --rotate normal &
nitrogen --set-scaled --random ~/GitIt/Wallpapers-PC &
exec awesome
