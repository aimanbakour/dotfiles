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

# Homebrew – load shell env if installed (Linuxbrew/macOS)
if command -v brew >/dev/null 2>&1; then
  eval "$(brew shellenv)"
elif [[ -x "/home/linuxbrew/.linuxbrew/bin/brew" ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [[ -x "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
# Ensure Homebrew zsh completions are on fpath
hb_site_funcs="$(brew --prefix 2>/dev/null)/share/zsh/site-functions"
if [[ -d "$hb_site_funcs" ]]; then
  fpath=($hb_site_funcs $fpath)
fi


# XDG directories
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DOWNLOADS="$HOME/downloads"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Env
export BUN_INSTALL="$HOME/.bun"

# Paths (universal + OS-specific)
# Universal user bins
addToPathFront "$HOME/.local/bin"
addToPath      "$HOME/.local/scripts"
addToPath      "$HOME/.cargo/bin"
addToPathFront "$BUN_INSTALL/bin"
addToPathFront "$HOME/.volta/bin"

# macOS specific tools
if [[ "$OSTYPE" == darwin* ]]; then
  addToPathFront "/opt/homebrew/bin"
  addToPathFront "/Applications/OrbStack.app/Contents/MacOS/bin"
  # Example: uv’s macOS-specific venv path (safe if missing)
  addToPathFront "$HOME/.local/share/uv/python/cpython-3.13.5-macos-aarch64-none/bin"
fi

# Google Cloud SDK (if installed in HOME)
if [ -f "$HOME/google-cloud-sdk/path.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/path.zsh.inc"
fi
if [ -f "$HOME/google-cloud-sdk/completion.zsh.inc" ]; then
  . "$HOME/google-cloud-sdk/completion.zsh.inc"
fi

# OrbStack integration (macOS)
if [[ "$OSTYPE" == darwin* ]]; then
  source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :
fi
