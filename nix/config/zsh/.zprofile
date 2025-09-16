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

# Homebrew (macOS only)
if command -v brew &>/dev/null; then
    eval "$(brew shellenv)"
fi


# XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DOWNLOADS="$HOME/downloads"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Paths
addToPathFront "$HOME/.local/bin"
addToPathFront "$BUN_INSTALL/bin"

addToPath "$HOME/.cargo/bin"
addToPath "$HOME/.local/scripts"

