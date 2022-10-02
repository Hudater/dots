export PATH="/sbin:$HOME/.local/bin:$PATH"
export EDITOR="nvim"
export READER="zathura"
export VISUAL="nvim"
export CODEEDITOR="vscodium"
export TERMINAL="kitty"
export BROWSER="brave"
export COLORTERM="truecolor"
export WM="awesome"
#export RANGER_LOAD_DEFAULT_RC=FALSE
export QT_QPA_PLATFORMTHEME="qt5ct"
#export QT_STYLE_OVERRIDE=kvantum

#export LESS_TERMCAP_mb=$'\e[1;32m'
#export LESS_TERMCAP_md=$'\e[1;32m'
#export LESS_TERMCAP_me=$'\e[0m'
#export LESS_TERMCAP_se=$'\e[0m'
#export LESS_TERMCAP_so=$'\e[01;33m'
#export LESS_TERMCAP_ue=$'\e[0m'
#export LESS_TERMCAP_us=$'\e[1;4;31m'


##Setting path var
#if [ -d "/mnt/IT/Coding/Scripts" ] ; then
#  PATH="$PATH:/mnt/IT/Coding/Scripts"
#fi

##Ask to startx
if [[ -z $DISPLAY && $XDG_VTNR -le 12 ]];
then
echo "would you like to start X? (Y/n)"
while true; do
read REPLY
REPLY="${REPLY:=y}"
case $REPLY in
    [Yy]) exec startx ;;
    [Nn]) break ;;
    *) printf '%s/n' 'Please answer y or n.' ;;
esac
done
fi
