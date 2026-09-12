# Utils
alias 'l'='eza --icons --group-directories-first -la -gh'
alias 'ls'='eza --icons --group-directories-first -a'
alias 'c'='clear'
alias 'q'='exit'
alias 'root'='sudo -i'
alias '..'='cd ..'
alias '...'='cd ../../'
alias '....'='cd ../../../'
alias '//'='echo "blyattttt"'
alias 'grep'='grep --color=auto'
alias 'egrep'='egrep --color=auto'
alias 'fgrep'='fgrep --color=auto'
alias 'cp'="cp -i"
alias 'df'='df -h'
alias 'free'='free -m'
alias 'pr'='cd "$OLDPWD"'
alias extip='curl -sS https://www.daveeddy.com/ip'

# Conditional aliases
if command -v bat >/dev/null 2>&1
then
  alias 'cat'='bat'
elif
  command -v batcat >/dev/null 2>&1
then
  alias 'cat'='batcat'
fi

if command -v docker compose >/dev/null 2>&1
then
  alias 'docker-compose'='docker compose'
fi

# Applications
alias 'v'='nvim'
alias 'vi'='nvim'
alias 'svi'='sudoedit'
alias 'ping'='ping -c 5'
alias 'mksrv'='mkdocs serve -v --dev-addr=0.0.0.0:4444'
alias 'stl'='sudo systemctl'
alias 'paru'='yay'
alias 'k'='kubectl'
alias 'tf'='terraform'
alias 'tg'='terragrunt'
alias 'ot'='tofu'
alias 'ts'='tailscale'

# Crowdsec cscli
alias cslist="docker exec crowdsec cscli decisions list"

# Directories
alias 'cfg'='cd ~/.config'
alias 'sfs'='cd $SYNCFILES'
alias 'bench'='cd /mnt/files/bench_local'
alias 'proj'='cd $PROJECTS_DIR'
alias 'lrn'='cd ~/syncthing/Projects/learn'

# git
alias 'gc'='git clone'
alias 'gst'='git status'
alias 'ga'='git add'
alias 'gcmsg'='git commit -S -m'
alias 'gl'='git pull'
alias 'gp'='git push'

# Rarely used (yt-dl, fastboot etc)
alias 'yt'='yt-dlp'
alias 'ytb'='yt-dlp -f "bestvideo+bestaudio"'
alias 'sf'='sudo fastboot'
alias 'mirrors'='sudo reflector --latest 50 --protocol http --protocol https --sort rate --save /etc/pacman.d/mirrorlist'
