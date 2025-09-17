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


# bun completions (if installed in HOME)
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"



# Defer non-critical plugin loading for better performance
_try_source() {
  local rel="$1"
  local dirs=(
    /opt/homebrew/share
    /home/linuxbrew/.linuxbrew/share
    /usr/local/share
    /usr/share
    "${XDG_DATA_HOME:-$HOME/.local/share}"
    "$HOME/.zsh"
  )
  local d
  for d in ${dirs[@]}; do
    if [ -r "$d/$rel" ]; then
      source "$d/$rel"
      return 0
    fi
  done
  return 1
}

_load_plugins_deferred() {
  # zsh-syntax-highlighting
  _try_source zsh-syntax-highlighting/zsh-syntax-highlighting.zsh || true
  # zsh-autosuggestions
  _try_source zsh-autosuggestions/zsh-autosuggestions.zsh || true
  # Remove the hook after first run
  add-zsh-hook -d precmd _load_plugins_deferred
}

# Use zsh's precmd hook to load after first prompt
autoload -Uz add-zsh-hook
add-zsh-hook precmd _load_plugins_deferred


# Set up fzf key bindings and completion (compat with older Debian fzf)
if _has_cmd fzf; then
  if fzf --help 2>&1 | grep -q -- "--zsh"; then
    source <(fzf --zsh)
  else
    for p in \
      /usr/share/fzf/key-bindings.zsh \
      /usr/share/fzf/shell/key-bindings.zsh \
      /usr/share/doc/fzf/examples/key-bindings.zsh; do
      [ -r "$p" ] && source "$p" && break
    done
    for p in \
      /usr/share/fzf/completion.zsh \
      /usr/share/fzf/shell/completion.zsh \
      /usr/share/doc/fzf/examples/completion.zsh; do
      [ -r "$p" ] && source "$p" && break
    done
  fi
fi

# export FZF_DEFAULT_OPTS="--height=40%"

# Initialize zoxide (z command for smart directory jumping)
if _has_cmd zoxide; then
  eval "$(zoxide init zsh)"
fi

# Optimized compinit - only rebuild if older than 24h
autoload -U compinit
# Use XDG cache for compdump to avoid writing into the repo/config
_ZCACHEDIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
mkdir -p "$_ZCACHEDIR"
_ZCOMPFILE="$_ZCACHEDIR/.zcompdump"
if [[ -n ${_ZCOMPFILE}(#qN.mh+24) ]]; then
  compinit -d "$_ZCOMPFILE"
else
  compinit -C -d "$_ZCOMPFILE"
fi
# fzf-tab plugin if present (checks common system and user paths)
if [ -r /opt/homebrew/share/fzf-tab/fzf-tab.plugin.zsh ]; then
  source /opt/homebrew/share/fzf-tab/fzf-tab.plugin.zsh
elif [ -r /home/linuxbrew/.linuxbrew/share/fzf-tab/fzf-tab.plugin.zsh ]; then
  source /home/linuxbrew/.linuxbrew/share/fzf-tab/fzf-tab.plugin.zsh
elif [ -r /usr/local/share/fzf-tab/fzf-tab.plugin.zsh ]; then
  source /usr/local/share/fzf-tab/fzf-tab.plugin.zsh
elif [ -r /usr/share/fzf-tab/fzf-tab.plugin.zsh ]; then
  source /usr/share/fzf-tab/fzf-tab.plugin.zsh
elif [ -r "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/fzf-tab/fzf-tab.plugin.zsh" ]; then
  source "${XDG_DATA_HOME:-$HOME/.local/share}/zsh/fzf-tab/fzf-tab.plugin.zsh"
fi

# Better directory listings with eza (modern replacement for ls)
if _has_cmd eza; then
    # Core aliases
    alias ls='eza --icons --group-directories-first -a'
    alias ll='eza -la --no-user --time-style=+%m/%d-%H:%M'
    # Tree views
    alias lt='eza --icons --tree --level=2'
    alias lta='eza --icons --tree --level=2 -a'
fi

# Check that the function `starship_zle-keymap-select()` is defined.
# xref: https://github.com/starship/starship/issues/3418
if _has_cmd starship; then
  type starship_zle-keymap-select >/dev/null 2>&1 || eval "$(starship init zsh)"
fi


export EDITOR='nvim'
export VISUAL='nvim'

# Enable emacs mode in zsh  
bindkey -e
# Reduce vim mode switching delay
export KEYTIMEOUT=1

# Enable edit-command-line
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line

# Tmux sessionizer
bindkey -s '^f' 'tmux-sessionizer\n'


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


alias tmuxm='tmux new-session -A -s main'
alias vim='nvim'
alias ruff80="ruff format --line-length=80"

# Yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# Debian/Ubuntu provide fdfind instead of fd
if ! _has_cmd fd && _has_cmd fdfind; then
  alias fd=fdfind
fi
