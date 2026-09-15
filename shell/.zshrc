#####################################################################################
########################## REFACTORED #################################################
#####################################################################################
# Kiro CLI pre block. Keep at the top of this file.
#[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

##################################Sourcing#############################################
# source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme

##################################Other-Settings#########################################
#fixing compdef error for git
autoload -Uz compinit
compinit

zstyle ':completion:*' matcher-list '' \
'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' \
'+l:|?=** r:|?=**'

autoload -Uz compinit && compinit -i

##################################History-tweaks#########################################
# ## TODO: maybe in some utopian society there will be XDG compliance
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt EXTENDED_HISTORY       # timestamp each entry
setopt HIST_IGNORE_SPACE      # ignore commands starting with space
setopt HIST_IGNORE_DUPS       # ignore immediate dupes
setopt HIST_IGNORE_ALL_DUPS   # remove older dupe when new one added
setopt HIST_SAVE_NO_DUPS      # don't write dupes to file
setopt HIST_FIND_NO_DUPS      # skip dupes when searching
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY          # share across sessions live
setopt INC_APPEND_HISTORY     # write immediately, not just on exit

#Navigate to directories without ls
setopt autocd

#################################Plugins################################################
source ~/.config/zsh/git/git.plugin.zsh
source ~/.config/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.config/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ~/.config/zsh/plugins/zsh-256color.plugin.zsh
source ~/.config/zsh/docker-autocomplete.zsh
source ~/.config/zsh/headscale-autocomplete.zsh
source ~/.config/zsh/lxc-autocomplete.zsh
source ~/.config/zsh/gtrash-completion.zsh
source ~/.config/zsh/bootdev-completion.zsh
source ~/.config/zsh/netbird-completion.zsh
source ~/.config/zsh/coder-autocomplete.zsh
source ~/.config/zsh/helm-autocomplete.zsh
source ~/.config/zsh/zed-autocomplete.zsh

#vi mode for zsh
bindkey -v

##################################Aliases & Functions####################################
for f in "$HOME/.config/personal/pers-alias.zsh" \
         "$HOME/.config/personal/pers-func.zsh" \
         "$HOME/.config/work/work-alias.zsh" \
         "$HOME/.config/work/work-func.zsh"; do
  [ -f "$f" ] && source "$f"
done

# Created by `pipx` on 2025-03-15 20:39:09
export PATH="$PATH:/home/putin/.local/bin"

autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/bin/terraform
complete -o nospace -C /opt/homebrew/bin/terraform terraform

# Generated for envman. Do not edit.
[ -s "$HOME/.config/envman/load.sh" ] && source "$HOME/.config/envman/load.sh"

#[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# opencode
export PATH=$HOME/.opencode/bin:$PATH

# Load Angular CLI autocompletion.
# source <(ng completion script)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

if [[ "$TERM_PROGRAM" != "kiro" ]]; then
    eval "$(starship init zsh)"
else
    PROMPT='%~ %$ '
fi

##################################fzf#####################################################
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

# Kiro CLI post block. Keep at the bottom of this file.
#[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"

if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
  source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi

# Added by Antigravity CLI installer
export PATH="/Users/harshit_tech/.local/bin:$PATH"

# Added by Antigravity IDE
export PATH="/Users/harshit_tech/.antigravity-ide/antigravity-ide/bin:$PATH"

# Added by cua-driver-rs installer — see https://github.com/trycua/cua
export PATH="/Users/harshit_tech/.local/bin:$PATH"
unset SSH_AUTH_SOCK
