# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

##################################Sourcing#############################################
#
#Sourcing powerlevel10k theme
# source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

#aliasrc source
[ -f "$HOME/.aliasrc" ] && source "$HOME/.aliasrc"

##################################Other-Settings#########################################
#
#fixing compdef error for git
autoload -Uz compinit
compinit

# Allow for autocomplete to be case insensitive
zstyle ':completion:*' matcher-list '' \
'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
'+l:|?=** r:|?=**'

# Preferred editor for local and remote sessions
#if [[ -n $SSH_CONNECTION ]]; then
#  export EDITOR='vim'
#  else
#  export EDITOR='nvim'
# fi

# Initialize the autocompletion
autoload -Uz compinit && compinit -i

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
# [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#SET VIM AS MANPAGER
#export MANPAGER="/bin/sh -c \"col -b | vim -c 'set ft=man ts=8 nomod nolist nonu noma' -\""
### Man to bat



#################################History-tweaks#########################################
#
#Increase history size file
HISTFILE=~/.zsh_history
SAVEHIST=10000
HISTSIZE=10000
setopt HIST_IGNORE_SPACE


#Navigate to directories without ls
setopt autocd

#Delete empty lines from history file
setopt HIST_REDUCE_BLANKS

#Do not add history and fc commands to the history
setopt HIST_NO_STORE

#Delete duplicates in history
preexec() {
   echo "$(history 0 | sort -k2 -k1nr | \
   uniq -f1 | sort -n | cut -c8-)" > $HISTFILE
}

disable r
alias r=' reset'
hf() {
  echo "$(history 1 | sort -k2 -k1nr | \
  uniq -f1 | sort -n | cut -c8-)" > $HISTFILE
  BUFFER="r"; zle accept-line
}; zle -N hf; bindkey '^[[Z' hf # Shift+Tab

#Ignore a record starting with a space
setopt HIST_IGNORE_SPACE


#################################Plugins################################################
#
##colored man pages
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


## Sourcing plugins
#git
source ~/.zsh/git/git.plugin.zsh

#zsh-autosuggestion
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

#zsh-syntax-highlighting
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

#zsh-expand-all
#source ~/.zsh/zsh-expand-all.zsh

# zsh-256color
source ~/.zsh/plugins/zsh-256color.plugin.zsh

#vi mode for zsh
bindkey -v

# To customize prompt, run `p10k configure` or edit ~/GitIt/dots/zsh/.p10k.zsh.
# [[ ! -f ~/GitIt/dots/zsh/.p10k.zsh ]] || source ~/GitIt/dots/zsh/.p10k.zsh

eval "$(starship init zsh)"

# Created by `pipx` on 2025-03-15 20:39:09
export PATH="$PATH:/home/putin/.local/bin"
