# Utils
addToPath() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH="$PATH:$1"
    fi
}

addToPathFront() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH="$1:$PATH"
    fi
}

eval "$(/opt/homebrew/bin/brew shellenv)"


# XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DOWNLOADS="$HOME/downloads"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Env
export BUN_INSTALL="$HOME/.bun"

# Paths
addToPathFront "$HOME/.local/share/uv/python/cpython-3.13.5-macos-aarch64-none/bin"
addToPathFront "/opt/homebrew/bin"
addToPathFront "$BUN_INSTALL/bin"
addToPathFront "$HOME/.volta/bin"
addToPathFront "/Applications/OrbStack.app/Contents/MacOS/bin"
addToPathFront "$HOME/.local/bin"

addToPath "$HOME/.cargo/bin"
addToPath "$HOME/.local/scripts"

# Google Cloud SDK
if [ -f '/Users/aiman/google-cloud-sdk/path.zsh.inc' ]; then
    . '/Users/aiman/google-cloud-sdk/path.zsh.inc'
fi

if [ -f '/Users/aiman/google-cloud-sdk/completion.zsh.inc' ]; then
    . '/Users/aiman/google-cloud-sdk/completion.zsh.inc'
fi

# Added by OrbStack: command-line tools and integration
# This won't be added again if you remove it.
source ~/.orbstack/shell/init.zsh 2>/dev/null || :
