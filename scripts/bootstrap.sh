#!/usr/bin/env bash
# scripts/bootstrap.sh
set -euo pipefail

need() { command -v "$1" >/dev/null 2>&1; }

# Locate flake: repo root or ./nix/
find_flake() {
  local repo; repo="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
  if   [ -f "$repo/flake.nix" ];     then echo "$repo"
  elif [ -f "$repo/nix/flake.nix" ]; then echo "$repo/nix"
  else echo "ERROR: flake.nix not found in repo root or ./nix/"; exit 1
  fi
}

FLAKE="$(find_flake)"

# Ensure curl (best effort, Debian/Ubuntu common)
if ! need curl; then
  (need apt-get && apt-get update -y && apt-get install -y curl xz-utils git) || true
fi

if [ "$(id -u)" -eq 0 ]; then
  # Running as root
  if [ -d /run/systemd/system ] || need systemctl; then
    echo ">> Installing Nix (multi-user daemon)..."
    sh <(curl -L https://nixos.org/nix/install) --daemon
    . /etc/profile.d/nix.sh
    mkdir -p /etc/nix
    echo "experimental-features = nix-command flakes" > /etc/nix/nix.conf
    echo ">> Applying Home-Manager (#root)..."
    nix --extra-experimental-features 'nix-command flakes' \
      run github:nix-community/home-manager -- switch --flake "$FLAKE#root"
  else
    # No systemd → single-user under a normal user
    user=aiman
    echo ">> Ensuring user '$user' exists..."
    id -u "$user" >/dev/null 2>&1 || useradd -m -s /bin/bash "$user" 2>/dev/null || adduser --disabled-password --gecos "" --shell /bin/bash "$user"
    echo ">> Preparing /nix for single-user..."
    mkdir -p /nix
    chown -R "$user":"$user" /nix
    echo ">> Installing Nix (single-user) for $user and applying HM (#current)..."
    su - "$user" -c "bash -lc 'set -e; \
      sh <(curl -L https://nixos.org/nix/install) --no-daemon; \
      . \$HOME/.nix-profile/etc/profile.d/nix.sh; \
      mkdir -p \$HOME/.config/nix; printf \"experimental-features = nix-command flakes\n\" > \$HOME/.config/nix/nix.conf; \
      cd \$HOME/dotfiles 2>/dev/null || true; \
      nix --extra-experimental-features \"nix-command flakes\" \
        run github:nix-community/home-manager -- switch --impure --flake \"$FLAKE#current\"'"
    echo "✅ Done. Login as '$user' (su - $user) and run: exec zsh -l"
  fi
else
  # Non-root → single-user for current user
  if ! need nix; then
    echo ">> Installing Nix (single-user) for $USER ..."
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
    . "$HOME/.nix-profile/etc/profile.d/nix.sh"
  else
    . "$HOME/.nix-profile/etc/profile.d/nix.sh" 2>/dev/null || true
  fi
  mkdir -p "$HOME/.config/nix"
  echo "experimental-features = nix-command flakes" > "$HOME/.config/nix/nix.conf"
  echo ">> Applying Home-Manager (#current)..."
  nix --extra-experimental-features 'nix-command flakes' \
    run github:nix-community/home-manager -- switch --impure --flake "$FLAKE#current"
  echo "✅ Done. Run: exec zsh -l"
fi
