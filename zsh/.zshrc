# Command availability cache for performance
typeset -A _cmd_cache
_has_cmd() {
  [[ -n $_cmd_cache[$1] ]] || _cmd_cache[$1]=$(command -v $1 &>/dev/null && echo 1 || echo 0)
  (( _cmd_cache[$1] ))
}

# Better ZSH options
setopt AUTO_CD              # cd by typing directory name
setopt INTERACTIVE_COMMENTS # Allow comments in interactive mode
setopt NO_CASE_GLOB        # Case insensitive globbing
setopt EXTENDED_GLOB       # Extended globbing
setopt AUTO_LIST           # Automatically list choices on ambiguous completion
setopt AUTO_MENU           # Automatically use menu completion
unsetopt CORRECT_ALL
unsetopt CORRECT
# History settings
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits

setopt SHARE_HISTORY          # Share history between all sessions
setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicate entries first
setopt HIST_IGNORE_DUPS       # Don't record duplicates
setopt HIST_IGNORE_ALL_DUPS     # Delete an old recorded event if a new event is a duplicate
setopt HIST_FIND_NO_DUPS        # Do not display a previously found event
setopt HIST_SAVE_NO_DUPS        # Do not write a duplicate event to the history file
setopt HIST_VERIFY              # Do not execute immediately upon history expansion
setopt HIST_IGNORE_SPACE      # Don't record entries starting with a space



# Directory navigation
alias ..='cd ..'
alias ~='cd ~'

# System commands
alias c='clear'
alias h='history'

# Git aliases
alias g='git'
alias gs='git status -sb'
alias glog='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias ga='git add'
alias gcm='git commit -m'
alias gca='git commit --amend --no-edit'  # Amend without changing message
alias gc='git checkout'
alias gp='git push'
alias gl='git pull'
alias gpf='git push --force'
# git commit "update" and push
alias gcp='git commit -am "update" && git push'

# Claude code
alias claude-yolo='claude --dangerously-skip-permissions'

# Kill port 8000
alias k8000='lsof -ti:8000 | xargs kill -9'
alias k3000='lsof -ti:3000 | xargs kill -9'


# bun completions
[ -s "/Users/aiman/.bun/_bun" ] && source "/Users/aiman/.bun/_bun"



# Defer non-critical plugin loading for better performance
_load_plugins_deferred() {
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  # Remove the hook after first run
  add-zsh-hook -d precmd _load_plugins_deferred
}

# Use zsh's precmd hook to load after first prompt
autoload -Uz add-zsh-hook
add-zsh-hook precmd _load_plugins_deferred


# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# Optimized compinit - only rebuild if older than 24h
autoload -U compinit
if [[ -n ${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi
source /opt/homebrew/share/fzf-tab/fzf-tab.plugin.zsh

# FZF Configuration and aliases
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

# Better directory listings with eza (modern replacement for ls)
if _has_cmd eza; then
    # Core aliases
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -la --no-user --time-style=+%m/%d-%H:%M'
    # Tree views
    alias lt='eza --icons --tree --level=2'
    alias lta='eza --icons --tree --level=2 -a'
fi

# Check that the function `starship_zle-keymap-select()` is defined.
# xref: https://github.com/starship/starship/issues/3418
type starship_zle-keymap-select >/dev/null || \
  {
    eval "$(starship init zsh)"
  }

# Enhanced history search
# TODO deleted fh
bindkey '^R' fzf-history-widget  # Bind Ctrl-R to your existing fh function

export EDITOR='nvim'
export VISUAL='nvim'

# Enable vim mode in zsh
bindkey -v
# Reduce vim mode switching delay
export KEYTIMEOUT=1


mkcd() { mkdir -p "$@" && cd "$@"; }
extract() {
  if [ -f "$1" ] ; then
    case "$1" in
      *.tar.bz2|*.tbz2) tar xvjf "$1" ;;
      *.tar.gz|*.tgz) tar xvzf "$1" ;;
      *.tar.xz|*.txz) tar xvJf "$1" ;;
      *.tar.Z) tar xvZf "$1" ;;
      *.tar) tar xvf "$1" ;;
      *.zip) unzip "$1" ;;
      *.rar) unrar x "$1" ;;
      *.7z) 7z x "$1" ;;
      *.gz) gunzip "$1" ;;
      *.bz2) bunzip2 "$1" ;;
      *.xz) unxz "$1" ;;
      *.Z) uncompress "$1" ;;
      *) echo "Cannot extract '$1'" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}


function dev() {
    local dir
    dir=$(fd --type d --max-depth 1 . ~/Developer/ | fzf --preview 'eza --icons --tree --level=1 {}')
    [ -n "$dir" ] && z "$dir"
}

function doc() {
    local dir
    dir=$(fd --type d --max-depth 1 . ~/Documents/ | fzf --preview 'eza --icons --tree --level=1 {}')
    [ -n "$dir" ] && z "$dir"
}

function myip() {
    curl -s "https://ipinfo.io/json" | jq '{
        "IP": .ip,
        "City": .city,
        "Region": .region,
        "Country": .country,
        "Location": .loc,
        "Organization": .org
    }' || echo "Unable to retrieve IP information"
}

function netcheck() {
    if ping -c 1 8.8.8.8 &> /dev/null; then
        echo "🌐 Internet is up 🚀"
    else
        echo "🌐 Internet is down 🚫"
    fi
}

function netspeed() {
    curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
}

# Tailscale
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# Tmux
alias tmuxm='tmux new-session -A -s main'

alias vim='nvim'

alias ruff80="ruff format --line-length=80"

