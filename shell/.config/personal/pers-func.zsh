#################################################KEYBINDS###################################
bindkey "^a" "beginning-of-line"
bindkey "^e" "end-of-line"
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word

# Colored man pages
if [[ "$OSTYPE" = solaris* ]]
then
	if [[ ! -x "$HOME/bin/nroff" ]]
	then
		mkdir -p "$HOME/bin"
		cat > "$HOME/bin/nroff" <<EOF
#!/bin/sh
if [ -n "\$_NROFF_U" -a "\$1,\$2,\$3" = "-u0,-Tlp,-man" ]; then
	shift
	exec /usr/bin/nroff -u\$_NROFF_U "\$@"
fi
#-- Some other invocation of nroff
exec /usr/bin/nroff "\$@"
EOF
		chmod +x "$HOME/bin/nroff"
	fi
fi

function colored() {
	command env \
		LESS_TERMCAP_mb=$(printf "\e[1;31m") \
		LESS_TERMCAP_md=$(printf "\e[1;31m") \
		LESS_TERMCAP_me=$(printf "\e[0m") \
		LESS_TERMCAP_se=$(printf "\e[0m") \
		LESS_TERMCAP_so=$(printf "\e[1;44;33m") \
		LESS_TERMCAP_ue=$(printf "\e[0m") \
		LESS_TERMCAP_us=$(printf "\e[1;32m") \
		PAGER="${commands[less]:-$PAGER}" \
		_NROFF_U=1 \
		PATH="$HOME/bin:$PATH" \
			"$@"
}

function man() {
	colored man "$@"
}

hf() {
  echo "$(history 1 | sort -k2 -k1nr | \
  uniq -f1 | sort -n | cut -c8-)" > $HISTFILE
  BUFFER="r"; zle accept-line
}; zle -N hf; bindkey '^[[Z' hf # Shift+Tab

# Docker ps
function dkr () {
  if [[ "$@" == "ps -a" ]]; then
    command docker ps --all --format "table {{.Names}}\t{{.ID}}\t{{.Image}}\t{{.RunningFor}}\t{{.Status}}\t{{.State}}\t{{.Ports}}" \
    | (read -r; printf "%s\n" "$REPLY"; sort -k 1 )
  elif [[ "$@" == "ps" ]]; then
    command docker ps --format "table {{.Names}}\t{{.ID}}\t{{.Image}}\t{{.RunningFor}}\t{{.Status}}\t{{.State}}\t{{.Ports}}" \
    | (read -r; printf "%s\n" "$REPLY"; sort -k 1 )
  else
    command docker "$@"
  fi
}

# Create directory with docker-compose.yml, deploy.sh file with chmod +x and README.md
function dkdir () {
  command mkdir -p "$1" "$BAK_CFG_DIR/$1" && \
  cd $1 && \
  cp -r ~/.config/templates/docker/compose/. . && \
  cp -r ~/.config/templates/docker/env/. "$BAK_CFG_DIR/$1/" && \
  sed -i "s/serviceName/$1/g" ./docker-compose.yml ./deploy.sh ./README.md && \
  chmod +x deploy.sh && \
  ls -la
}

# Create directory; cd into it; ls dir
# credit: https://gist.github.com/kallmanation/2027bb23242e59cb90141c803ffe2703
mkcd()
{
  mkdir -pv "$@" 2> >(sed s/mkdir/mcd/ 1>&2) && \
  cd "$_" && \
  ls -al;
}

### Function extract for common file formats ###
### From DT's gitlab
function extract {
if [ -z "$1" ]; then
    echo "Usage: extract <path/file_name>.<zip|rar|bz2|gz|tar|tbz2|tgz|Z|7z|xz|ex|tar.bz2|tar.gz|tar.xz>"
    echo "       extract <path/file_name_1.ext> [path/file_name_2.ext] [path/file_name_3.ext]"
else
    local SAVEIFS=$IFS
    IFS=$(echo -en "\n\b")
    for n in "$@"
    do
      if [ -f "$n" ] ; then
          case "${n%,}" in
            *.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
                        tar xvf "$n"       ;;
            *.lzma)      unlzma ./"$n"      ;;
            *.bz2)       bunzip2 ./"$n"     ;;
            *.cbr|*.rar)       unrar x -ad ./"$n" ;;
            *.gz)        gunzip ./"$n"      ;;
            *.cbz|*.epub|*.zip)       unzip ./"$n"       ;;
            *.z)         uncompress ./"$n"  ;;
            *.7z|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg|*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
                        7z x ./"$n"        ;;
            *.xz)        unxz ./"$n"        ;;
            *.exe)       cabextract ./"$n"  ;;
            *.cpio)      cpio -id < ./"$n"  ;;
            *.cba|*.ace)      unace x ./"$n"      ;;
            *)
                        echo "extract: '$n' - unknown archive method"
                        IFS=$SAVEIFS
                        return 1
                        ;;
          esac
      else
          echo "'$n' - file does not exist"
          IFS=$SAVEIFS
          return 1
      fi
    done
    IFS=$SAVEIFS
fi
}

## From Christitus
# Nala alias to apt
apt() {
  command nala "$@"
}
sudo() {
  if [ "$1" = "apt" ]; then
    shift
    command sudo nala "$@"
  else
    command sudo "$@"
  fi
}

# Usage: k8s_context <namespace_name>
k8s_context() {
    if [ -n "$1" ]; then
        kubectl config set-context --current --namespace="$1"
        echo "Context namespace updated to: $1"
    else
        echo "Error: Please specify a namespace."
        echo "Usage: k8s_context <namespace_name>"
    fi
}

# Crowdsec cscli
csdel() {
    docker exec crowdsec cscli decisions delete --ip "$1"
}
