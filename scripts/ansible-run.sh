#!/usr/bin/env bash
set -euo pipefail

# Convenience wrapper for running our Ansible playbook with sane defaults.
# - Uses uvx to run a modern ansible-core (no system Python conflicts)
# - Points to repo's ansible.cfg and inventory automatically
# - Provides simple flags for user, tags, skip-tags

need() { command -v "$1" >/dev/null 2>&1; }
log()  { printf "\033[1;34m>>\033[0m %s\n" "$*"; }
err()  { printf "\033[1;31m!!\033[0m %s\n" "$*" >&2; }

usage() {
  cat <<'EOF'
Usage: scripts/ansible-run.sh [--user <name>] [--tags <t1,t2>] [--skip-tags <t3,t4>] [--] [extra ansible args]

Examples:
  scripts/ansible-run.sh --user aiman --tags packages,starship -vv
  scripts/ansible-run.sh --user aiman --tags sudo
  scripts/ansible-run.sh --user aiman --tags stow -- --start-at-task "Stow dotfiles packages"

Notes:
  - Runs ansible/playbook.yml with inventory ansible/inventory.ini
  - Uses uvx (https://astral.sh/uv). If uvx is not found, it suggests running scripts/bootstrap-server.sh
EOF
}

TARGET_USER="${SUDO_USER:-${USER:-aiman}}"
TAGS=""
SKIP_TAGS=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --user|-u)
      if [[ $# -lt 2 ]]; then err "--user requires a value"; usage; exit 2; fi
      TARGET_USER="$2"; shift 2 ;;
    --tags)
      if [[ $# -lt 2 ]]; then err "--tags requires a value"; usage; exit 2; fi
      TAGS="$2"; shift 2 ;;
    --skip-tags)
      if [[ $# -lt 2 ]]; then err "--skip-tags requires a value"; usage; exit 2; fi
      SKIP_TAGS="$2"; shift 2 ;;
    -h|--help)   usage; exit 0 ;;
    --) shift; break ;;
    *) break ;;
  esac
done

# Ensure uvx exists
if ! need uvx; then
  # Try to add ~/.local/bin to PATH (typical uv install location)
  export PATH="$HOME/.local/bin:$PATH"
fi
if ! need uvx; then
  err "uvx not found. Please run scripts/bootstrap-server.sh (as root) first, or install uv from https://astral.sh/uv"
  exit 1
fi

# Ensure we run from repo root
cd "$(dirname "${BASH_SOURCE[0]}")/.."

export ANSIBLE_CONFIG=ansible/ansible.cfg
export ANSIBLE_INVENTORY=ansible/inventory.ini

# Elevate to root automatically when running sudo-related tasks or full run
NEED_ROOT=0
if [[ -z "$TAGS" || ",${TAGS}," == *",sudo,"* ]]; then
  NEED_ROOT=1
fi
if [[ $NEED_ROOT -eq 1 && $EUID -ne 0 && -z "${ANSIBLE_RUN_ELEVATED:-}" ]]; then
  if need sudo; then
    log "Elevating to root for sudo-related tasks"
    export ANSIBLE_RUN_ELEVATED=1
    exec sudo -E "${BASH_SOURCE[0]}" ${TARGET_USER:+--user "$TARGET_USER"} ${TAGS:+--tags "$TAGS"} ${SKIP_TAGS:+--skip-tags "$SKIP_TAGS"} -- "$@"
  else
    err "sudo not available. Run this script as root for initial sudo setup."
    exit 1
  fi
fi

cmd=(uvx --from ansible-core ansible-playbook -i ansible/inventory.ini ansible/playbook.yml -e "user=${TARGET_USER}")

[[ -n "$TAGS" ]] && cmd+=(--tags "$TAGS")
[[ -n "$SKIP_TAGS" ]] && cmd+=(--skip-tags "$SKIP_TAGS")

# Pass through any remaining args directly to ansible-playbook
if [[ $# -gt 0 ]]; then
  cmd+=("$@")
fi

log "Running: ${cmd[*]}"
# Enable trace if ANSIBLE_RUN_DEBUG=1
if [[ "${ANSIBLE_RUN_DEBUG:-0}" == "1" ]]; then set -x; fi
exec "${cmd[@]}"
