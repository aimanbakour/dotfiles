#!/usr/bin/env bash
set -Eeuo pipefail

# Bootstrap a fresh Ubuntu/Debian host using uv + Ansible (modern, isolated)
# - Installs minimal prerequisites via apt
# - Installs uv (https://astral.sh/uv) for isolated Python tooling
# - Uses uvx to run a modern ansible-core, no system Python conflicts
# - Clones this repo (temp) and runs the playbook

DEFAULT_REPO_URL="https://github.com/aimanbakour/dotfiles"
DEFAULT_BRANCH="main"

need() { command -v "$1" >/dev/null 2>&1; }
log()  { printf "\033[1;34m>>\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31m!!\033[0m %s\n" "$*" >&2; }

usage() {
  cat <<EOF
Usage: $0 [--user <name>] [--repo <url>] [--branch <name>]

Options:
  --user    Target user to configure (default: SUDO_USER, else current user if not root, else 'aiman').
  --repo    Dotfiles repo URL (default: $DEFAULT_REPO_URL)
  --branch  Git branch (default: $DEFAULT_BRANCH)
EOF
}

TARGET_USER=""
REPO_URL="$DEFAULT_REPO_URL"
BRANCH="$DEFAULT_BRANCH"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --user)   TARGET_USER="$2"; shift 2 ;;
    --repo)   REPO_URL="$2";   shift 2 ;;
    --branch) BRANCH="$2";     shift 2 ;;
    -h|--help) usage; exit 0 ;;
    *) err "Unknown arg: $1"; usage; exit 1 ;;
  esac
done

# Ensure root (re-exec with sudo if possible)
if [[ $EUID -ne 0 ]]; then
  if need sudo; then
    exec sudo -E bash "$0" ${TARGET_USER:+--user "$TARGET_USER"} --repo "$REPO_URL" --branch "$BRANCH"
  else
    err "Please run as root or install sudo."; exit 1
  fi
fi

# OS sanity check
if [[ -r /etc/os-release ]]; then
  . /etc/os-release
  case "${ID_LIKE:-$ID}" in
    *debian*|*ubuntu*) : ;; 
    *) err "Unsupported distro ($ID). This script targets Debian/Ubuntu."; exit 1 ;;
  esac
fi

# Decide target user
if [[ -z "$TARGET_USER" ]]; then
  if [[ -n "${SUDO_USER:-}" && "${SUDO_USER}" != "root" ]]; then
    TARGET_USER="$SUDO_USER"
  elif [[ -n "${USER:-}" && "${USER}" != "root" ]]; then
    TARGET_USER="$USER"
  else
    TARGET_USER="aiman"
  fi
fi

log "Target user: $TARGET_USER"
log "Repo: $REPO_URL ($BRANCH)"

export DEBIAN_FRONTEND=noninteractive
log "Installing prerequisites via apt (curl, git, stow, python3, python3-apt, ca-certificates)"
apt-get update -y
apt-get install -y --no-install-recommends \
  ca-certificates curl git stow python3 python3-apt

# Install uv for the root user (provides uv and uvx under ~/.local/bin)
if ! need uvx; then
  log "Installing uv (Astral)"
  curl -fsSL https://astral.sh/uv/install.sh | sh
  export PATH="${HOME}/.local/bin:${PATH}"
fi
command -v uvx >/dev/null || { err "uvx not found after install"; exit 1; }

# Temp clone to run the playbook
WORKDIR="/tmp/dotfiles-bootstrap"
if [[ -d "$WORKDIR/.git" ]]; then
  log "Updating existing clone at $WORKDIR"
  git -C "$WORKDIR" remote set-url origin "$REPO_URL"
  git -C "$WORKDIR" fetch --depth=1 origin "$BRANCH"
  git -C "$WORKDIR" checkout -qf FETCH_HEAD
else
  log "Cloning $REPO_URL to $WORKDIR"
  rm -rf "$WORKDIR"
  git clone --depth=1 --branch "$BRANCH" "$REPO_URL" "$WORKDIR"
fi

cd "$WORKDIR"

# Run ansible-playbook using uvx (isolated, latest ansible-core)
log "Running Ansible playbook (ansible-core via uvx) for user '$TARGET_USER'"
uvx --from ansible-core ansible-playbook -i ansible/inventory.ini ansible/playbook.yml -e "user=$TARGET_USER"

log "All set. If a new user was created, switch to it:"
echo "  su - $TARGET_USER"
echo "Then start a fresh shell to load zsh and config:"
echo "  exec zsh -l"
