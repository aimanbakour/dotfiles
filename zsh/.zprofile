
eval "$(/opt/homebrew/bin/brew shellenv)"

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :

# XDG base directories (freedesktop.org spec)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DOWNLOADS="$HOME/downloads"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Add uv Python to PATH (before homebrew)
export PATH="$HOME/.local/share/uv/python/cpython-3.13.5-macos-aarch64-none/bin:$PATH"
# Add Homebrew to PATH if missing (add to top of .zshrc)
export PATH="/opt/homebrew/bin:$PATH"  # For Apple Silicon Macs
export PATH="$HOME/.volta/bin:$PATH"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Orbstack
export PATH="/Applications/OrbStack.app/Contents/MacOS/bin:$PATH"

# Ensure unique PATH entries
typeset -U PATH path

. "$HOME/.cargo/env"
. "$HOME/.local/bin/env"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/aiman/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/aiman/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/aiman/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/aiman/google-cloud-sdk/completion.zsh.inc'; fi
