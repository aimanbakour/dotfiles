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

# XDG base directories (freedesktop.org spec)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DOWNLOADS="$HOME/downloads"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"

command -v pyenv >/dev/null 2>&1 && eval "$(pyenv init -)"

# Add Homebrew to PATH if missing (add to top of .zshrc)
export PATH="/opt/homebrew/bin:$PATH"  # For Apple Silicon Macs
export PATH="$HOME/.volta/bin:$PATH"





# Directory navigation
alias ..='cd ..'
alias ..2='cd ../..'
alias ..3='cd ../../..'
alias ..4='cd ../../../..'
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
alias gcae='git commit --amend'           # Amend with message edit
alias gc='git checkout'
alias grs='git restore --staged'
alias gp='git push'
alias gl='git pull'
alias gpf='git push --force'
# git commit "update" and push
alias gcp='git commit -am "update" && git push'

# Claude code
alias claude-yolo='claude --dangerously-skip-permissions'

function gshow() {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index \
        --bind="ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
                FZF-EOF"
}
fgb() {
    git branch --all --sort=-committerdate |
        grep -v HEAD |
        fzf --preview 'git log --color=always --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed "s/.* //" <<< {})' |
        sed "s/.* //"
}
# Interactive branch checkout
gco() {
    local branch
    branch=$(fgb)
    if [[ -n "$branch" ]]; then
        git checkout $(echo "$branch" | sed "s#remotes/[^/]*/##")
    fi
}

# Interactive git add with preview
gai() {
    local files
    files=$(git status -s |
        fzf --multi --preview 'git diff --color=always {2}' |
        awk '{print $2}')
    if [[ -n "$files" ]]; then
        git add $(echo "$files")
        git status -s
    fi
}




# Kill port 8000
alias k8000='lsof -ti:8000 | xargs kill -9'
alias k3000='lsof -ti:3000 | xargs kill -9'


# bun completions
[ -s "/Users/aiman/.bun/_bun" ] && source "/Users/aiman/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Ensure unique PATH entries
typeset -U PATH path

. "$HOME/.cargo/env"


source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh


# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

autoload -U compinit; compinit
source /opt/homebrew/share/fzf-tab/fzf-tab.plugin.zsh

# FZF Configuration and aliases

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"
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

# Useful fzf aliases and functions
alias ff="fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'"  # File search with preview
# Alternative version that prints the command to your prompt without executing
function fh() {
    print -z $(history 0 | awk '{ $1=""; print substr($0,2)}' | \
        fzf --height 40% \
            --tac \
            --reverse \
            --no-sort \
            --multi \
            --exact \
            --cycle \
            --query "$LBUFFER")
}

fport() {
    local port
    if [ $# -eq 0 ]; then
        # If no port provided, show all used ports with fzf
        port=$(lsof -i -P -n | grep LISTEN | fzf --header='Select port to kill' | awk '{print $9}' | sed 's/.*://')
    else
        port=$1
    fi
    
    if [ ! -z "$port" ]; then
        local pid=$(lsof -ti:$port)
        if [ ! -z "$pid" ]; then
            echo "Killing process on port $port (PID: $pid)"
            kill -9 $pid
        else
            echo "No process found on port $port"
        fi
    fi
}


# Git specific fzf functions
# Checkout git branch
fbr() {
    local branches branch
    branches=$(git branch --all | grep -v HEAD) &&
    branch=$(echo "$branches" |
             fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
    git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# Git commit browser
fshow() {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --preview "echo {} | grep -o '[a-f0-9]\{7\}' | head -1 |
                 xargs -I % sh -c 'git show --color=always %'" \
        --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}
# Search through git files
fgf() {
    git ls-files | fzf --preview 'bat --style=numbers --color=always --line-range :500 {}'
}

# Better directory listings with eza (modern replacement for ls)
if command -v eza > /dev/null; then
       # Core aliases
    alias ls='eza --icons --group-directories-first'
    alias ll='eza -la --no-user --time-style=+%m/%d-%H:%M'
    alias la='eza --icons --group-directories-first -la --git'
    
    # Tree views
    alias lt='eza --icons --tree --level=2'
    alias ltl='eza --icons --tree --level=2 -l --git'
    alias lta='eza --icons --tree --level=2 -a'
    
    # Specialized views
    alias ldot='eza -a | grep "^\."'            # Show only dot files
    alias ldir='eza -lD --icons'                # Show only directories
    alias lfile='eza --icons -lF --color=always | grep "^-"' # Show only files
    
    # Sorted views
    alias lsize='eza -l --icons --sort=size --reverse'   # Sort by size
    alias lmod='eza -l --icons --sort=modified'          # Sort by modified date
    alias lold='eza -l --icons --sort=modified --reverse' # Sort by modified date (oldest first)
    alias lext='eza -l --icons --sort=extension'         # Sort by extension
    
    # Detailed views
    alias ldetail='eza -l --icons --git --time-style=long-iso --blocksize --created --modified' # Detailed view
    alias lgit='eza -l --icons --git-ignore --git'       # Show git status
    alias lperms='eza -l --icons --octal-permissions'    # Show octal permissions
    
    # Special views
    alias llinks='eza -l --icons --links'                # Show number of links
    alias linode='eza -l --icons --inode'                # Show inode numbers
    alias lsecurity='eza -l --icons --context'           # Show security context
    
    # Grid and formatting options
    alias lgrid='eza --icons --grid'                     # Grid view
    alias lacross='eza --icons --across'                 # Across view
    alias lclassify='eza --icons --classify'             # Add type indicators
    
    # Time-based views
    alias laccessed='eza -l --icons --accessed --sort=accessed'    # Sort by access time
    alias lcreated='eza -l --icons --created --sort=created'       # Sort by creation time
    alias lchanged='eza -l --icons --changed --sort=changed'       # Sort by change time
    
    # Combination views
    alias lall='eza -la --icons --git --header --long --modified --created --accessed --blocksize --inode' # Everything
    alias ldev='eza -l --icons --git --header --blocksize --time-style=long-iso' # Developer-friendly view
    
    # Git-specific views
    alias lrepos='eza -l --icons --git-repos --git-repos-no-status' # Show git repositories
    alias lgitall='eza -l --icons --git --git-repos --git-ignore'   # All git information

fi


# Check that the function `starship_zle-keymap-select()` is defined.
# xref: https://github.com/starship/starship/issues/3418
type starship_zle-keymap-select >/dev/null || \
  {
    eval "$(starship init zsh)"
  }

if command -v fd > /dev/null; then
    # Basic searches
    alias fdd='fd --type d'                # Find directories
    alias fdl='fd --type l'                # Find symlinks
    alias fde='fd --type e'                # Find empty files/directories
    
    # Find by type and time
    alias fdnew='fd --type f --changed-within 1h'      # Files created in last hour
    alias fdtoday='fd --type f --changed-within 24h'   # Files created today
    alias fdweek='fd --type f --changed-within 7d'     # Files created this week

    # Find by specific criteria
    alias fdsize='fd --type f -X du -h {} + | sort -rh | head -n 20'  # Largest files
    alias fdempty='fd --type d --empty'                               # Empty directories
    alias fddup='fd --type f -X md5sum {} + | sort | uniq -w32 -dD'  # Duplicate files
    
        # Development specific
    alias fdgit='fd --no-ignore --hidden --exclude .git'  # Include git ignored files
    alias fdenv='fd -H "^\.env.*"'                        # Find .env files
    alias fdconfig='fd -H "^\.config.*"'                  # Find config files
    alias fddocker='fd "docker-compose.*|Dockerfile.*"'   # Find Docker files


    # Search with specific criteria
    alias fdh='fd --hidden'                # Include hidden files
    alias fdg='fd --no-ignore'             # Include files ignored by .gitignore
    alias fda='fd --hidden --no-ignore'    # Include hidden and ignored files
    alias fdt='fd --type f --changed-within' # Files changed within time period
    
    # Extension-based search
    alias fdjs='fd -e js'                  # Find JavaScript files
    alias fdpy='fd -e py'                  # Find Python files
    alias fdmd='fd -e md'                  # Find Markdown files
    alias fdjson='fd -e json'              # Find JSON files
fi

if command -v zoxide > /dev/null; then
    eval "$(zoxide init zsh)"

    # Aliases for common operations
    alias j='z'                 # Quick jump to directory
    alias ji='zi'              # Interactive directory jump
    alias ja='zoxide add'      # Manually add a directory
    alias jr='zoxide remove'   # Remove a directory
    # Enhanced cd with zoxide
    alias cd='z'

    # Function to jump to directory and list contents
    cdl() {
        z "$@" && eza --icons --group-directories-first
    }
    jtop() {
        zoxide query --list | fzf --preview 'eza --icons --group-directories-first -l {}'
    }

fi

rgf() {
    result=$(rg --line-number --no-heading --color=always --smart-case "$*" |
        fzf --ansi \
            --color "hl:-1:underline,hl+:-1:underline:reverse" \
            --delimiter : \
            --preview 'bat --style=numbers --color=always --highlight-line {2} {1}' \
            --preview-window 'up,60%,border-bottom,+{2}+3/3,~3')
    [ -n "$result" ] && echo "$result" | cut -d':' -f1
}

# Enhanced history search
bindkey '^R' fzf-history-widget  # Bind Ctrl-R to your existing fh function

# Quick edit with neovim
fe() {
    local file
    file=$(fzf --preview 'bat --style=numbers --color=always --line-range :500 {}') &&
    [ -n "$file" ] && nvim "$file"
}

fenv() {
    printenv | sort | fzf \
        --header 'Environment Variables' \
        --preview 'echo {} | cut -d= -f2 | bat --style=numbers --color=always --language=sh' \
        --preview-window 'right:60%:wrap'
}

export EDITOR='nvim'
export VISUAL='nvim'

# Enable vim mode in zsh - DISABLED to avoid confusion with vim editor
# bindkey -v
# Reduce vim mode switching delay
# export KEYTIMEOUT=1

# Force emacs mode (normal terminal keybindings) to prevent vim conflicts
bindkey -e

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

# alias cat='bat'

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

# alias source='source ~/.zshrc'

function note() {
    local date=$(date +%Y-%m-%d)
    local time=$(date +%H:%M:%S)
    local note_dir="$HOME/terminal_notes"
    mkdir -p "$note_dir"
    echo "[$time] $*" >> "$note_dir/$date.md"
    echo "Note saved to $note_dir/$date.md"
}

function nedit() {
    local note_dir="$HOME/notes"
    local date_file="$note_dir/$(date +%Y-%m-%d).md"
    mkdir -p "$note_dir"
    nvim "$date_file"
}

function calc() {
    bc -l <<< "$@"
}

alias reload='source ~/.zshrc'

# Help function to show all custom functions and aliases
function zhelp() {
    echo "🔍 Git Functions & Aliases:"
    echo "  gshow()     - Interactive git commit browser with fzf"
    echo "  fgb()       - Interactive git branch selector" 
    echo "  gco()       - Interactive git checkout"
    echo "  gai()       - Interactive git add with preview"
    echo "  fbr()       - Fuzzy git branch checkout"
    echo "  fshow()     - Git commit browser with preview"
    echo "  fgf()       - Search git files with fzf"
    echo "  g, gs, glog - Basic git shortcuts"
    echo "  ga, gcm     - Add and commit"
    echo "  gcp         - Commit 'update' and push"
    echo ""
    echo "📁 Directory & File Management:"
    echo "  ls, ll, la  - Enhanced with eza (icons, git status)"
    echo "  lt, ltl     - Tree views (eza)"
    echo "  lsize, lmod - Sorted views by size/date"
    echo "  cdl()       - Jump to directory and list contents"
    echo "  jtop()      - Interactive directory jump with preview"
    echo "  dev()       - Navigate to ~/Developer subdirectories"
    echo "  doc()       - Navigate to ~/Documents subdirectories"
    echo "  mkcd()      - Create directory and cd into it"
    echo "  j, ji       - Zoxide jump commands"
    echo "  fd*         - Various fd (find) shortcuts"
    echo ""
    echo "🔎 Search & Edit Functions:"
    echo "  ff          - File search with preview"
    echo "  rgf()       - Search file contents with ripgrep and fzf"
    echo "  fe()        - Edit file selected with fzf"
    echo "  fh()        - Fuzzy history search"
    echo "  fsrch()     - Search and edit file at specific line"
    echo ""
    echo "🌐 Network & System:"
    echo "  myip()      - Show IP and location info"
    echo "  netcheck()  - Check internet connectivity"
    echo "  netspeed()  - Run speed test"
    echo "  sshm()      - SSH host selector from config"
    echo "  fport()     - Kill process on port (interactive if no arg)"
    echo "  k8000/k3000 - Kill ports 8000/3000"
    echo ""
    echo "📝 Notes & Utilities:"
    echo "  note()      - Quick note taking to ~/terminal_notes"
    echo "  nedit()     - Edit today's note file"
    echo "  calc()      - Calculator using bc"
    echo "  extract()   - Extract various archive formats"
    echo "  fenv()      - Browse environment variables"
    echo ""
    echo "⚡ Quick Commands:"
    echo "  c           - Clear screen"
    echo "  reload      - Reload .zshrc"
    echo "  zhelp       - Show this help"
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


function sshm() {
    local hosts=$(awk '/^Host / {print $2}' ~/.ssh/config | fzf)
    if [ -n "$hosts" ]; then
        ssh "$hosts"
    fi
}

function fsrch() {
    if [ -z "$1" ]; then
        echo "Usage: fsrch <search_term>"
        return 1
    fi
    local file_line=$(rg --line-number --no-heading "$1" | fzf --delimiter : --nth 1,2,3)
    if [ -n "$file_line" ]; then
        local file=$(echo "$file_line" | cut -d':' -f1)
        local line=$(echo "$file_line" | cut -d':' -f2)
        nvim +$line "$file"
    fi
}

function netspeed() {
    curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python -
}

# Orbstack
export PATH="/Applications/OrbStack.app/Contents/MacOS/bin:$PATH"

. "$HOME/.local/bin/env"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/aiman/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/aiman/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/aiman/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/aiman/google-cloud-sdk/completion.zsh.inc'; fi


# Tailscale
alias tailscale="/Applications/Tailscale.app/Contents/MacOS/Tailscale"

# Tmux
alias tmuxm='tmux new-session -A -s main'

alias vim='nvim'

alias ruff80="ruff format --line-length=80"
