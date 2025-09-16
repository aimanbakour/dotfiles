# Command availability cache for performance
typeset -A _cmd_cache
_has_cmd() {
  [[ -n $_cmd_cache[$1] ]] || _cmd_cache[$1]=$(command -v $1 &>/dev/null && echo 1 || echo 0)
  (( _cmd_cache[$1] ))
}

# -----------------------
# ZSH Options
# -----------------------
setopt AUTO_CD              # cd by typing directory name
setopt INTERACTIVE_COMMENTS # Allow comments in interactive mode
setopt NO_CASE_GLOB         # Case insensitive globbing
setopt EXTENDED_GLOB        # Extended globbing
setopt AUTO_LIST            # Auto list choices on ambiguous completion
setopt AUTO_MENU            # Auto use menu completion
unsetopt CORRECT_ALL
unsetopt CORRECT

# History
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=${XDG_STATE_HOME:-$HOME}/zsh/history
setopt EXTENDED_HISTORY INC_APPEND_HISTORY SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS HIST_SAVE_NO_DUPS HIST_VERIFY HIST_IGNORE_SPACE

# -----------------------
# Aliases
# -----------------------
alias ..='cd ..'
alias ~='cd ~'
alias c='clear'
alias h='history'

# Git
alias g='git'
alias gs='git status -sb'
alias glog='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias ga='git add'
alias gcm='git commit -m'
alias gca='git commit --amend --no-edit'
alias gc='git checkout'
alias gp='git push'
alias gl='git pull'
alias gpf='git push --force'
alias gcp='git commit -am "update" && git push'

# Kill ports (works both on Linux/macOS with lsof)
alias k8000='lsof -ti:8000 | xargs kill -9 2>/dev/null'
alias k3000='lsof -ti:3000 | xargs kill -9 2>/dev/null'

# -----------------------
# Plugin loading (deferred)
# -----------------------
_load_plugins_deferred() {
  if _has_cmd zsh-syntax-highlighting; then
    source "$(command -v zsh-syntax-highlighting)"
  elif [ -f /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
    source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  fi

  if _has_cmd zsh-autosuggestions; then
    source "$(command -v zsh-autosuggestions)"
  elif [ -f /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
    source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
  fi

  add-zsh-hook -d precmd _load_plugins_deferred
}

autoload -Uz add-zsh-hook
add-zsh-hook precmd _load_plugins_deferred

# -----------------------
# FZF
# -----------------------
if _has_cmd fzf; then
  source <(fzf --zsh)
fi

# Zoxide
if _has_cmd zoxide; then
  eval "$(zoxide init zsh)"
fi

# Compinit (cache rebuild only if older than 24h)
autoload -U compinit
if [[ -n ${XDG_CACHE_HOME:-$HOME/.cache}/zsh/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# fzf-tab
[ -f /usr/share/fzf-tab/fzf-tab.plugin.zsh ] && source /usr/share/fzf-tab/fzf-tab.plugin.zsh

# -----------------------
# eza instead of ls
# -----------------------
if _has_cmd eza; then
  alias ls='eza --icons --group-directories-first -a'
  alias ll='eza -la --no-user --time-style=+%m/%d-%H:%M'
  alias lt='eza --icons --tree --level=2'
  alias lta='eza --icons --tree --level=2 -a'
fi

# -----------------------
# Starship prompt
# -----------------------
if _has_cmd starship; then
  type starship_zle-keymap-select >/dev/null || eval "$(starship init zsh)"
fi

# -----------------------
# Editor / Keybinds
# -----------------------
export EDITOR='nvim'
export VISUAL='nvim'
bindkey -e
export KEYTIMEOUT=1
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^X^E' edit-command-line
bindkey -s '^f' 'tmux-sessionizer\n'

# -----------------------
# Functions
# -----------------------
mkcd() { mkdir -p "$@" && cd "$@"; }

extract() {
  if [ -f "$1" ]; then
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

dev() {
  local dir
  dir=$(fd --type d --max-depth 1 . ~/Developer/ 2>/dev/null | fzf --preview 'eza --icons --tree --level=1 {}')
  [ -n "$dir" ] && z "$dir"
}

doc() {
  local dir
  dir=$(fd --type d --max-depth 1 . ~/Documents/ 2>/dev/null | fzf --preview 'eza --icons --tree --level=1 {}')
  [ -n "$dir" ] && z "$dir"
}

myip() {
  _has_cmd jq || { echo "jq required"; return 1; }
  curl -s "https://ipinfo.io/json" | jq '{
    IP: .ip,
    City: .city,
    Region: .region,
    Country: .country,
    Location: .loc,
    Organization: .org
  }' || echo "Unable to retrieve IP information"
}

netcheck() {
  if ping -c 1 8.8.8.8 &>/dev/null; then
    echo "🌐 Internet is up 🚀"
  else
    echo "🌐 Internet is down 🚫"
  fi
}

netspeed() {
  curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
}


# -----------------------
# Misc aliases
# -----------------------
alias tmuxm='tmux new-session -A -s main'

# -----------------------
# Yazi integration
# -----------------------
y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}
