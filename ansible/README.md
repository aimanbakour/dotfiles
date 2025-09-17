# Ansible + Stow Setup

This playbook configures a user environment on Debian/Ubuntu using apt and GNU Stow to link the dotfiles in this repo.

What it does:
- Installs packages: zsh, tmux, neovim, stow, starship, and common CLIs.
- Installs Yazi on Debian/Ubuntu from the official GitHub binary release (default on).
- Creates ZDOTDIR wrappers in `~/.zshrc` and `~/.zprofile` that source `~/.config/zsh`.
- Ensures `~/.cache/zsh` exists for compdump files.
- Clones/updates this repo to `~/dotfiles` (if not already there).
- Uses stow to symlink packages into their targets.

Targets mapping (package -> target):
- zsh -> `~/.config/zsh`
- nvim -> `~/.config/nvim`
- tmux -> `~/.config/tmux`
- starship -> `~/.config` (creates `~/.config/starship.toml`)
- yazi -> `~/.config/yazi`
- zathura -> `~/.config/zathura`

Run locally on Ubuntu:
- With script: `./scripts/apply-ansible.sh`
- Or manually: `ansible-playbook -i ansible/inventory.ini ansible/playbook.yml`

Notes:
- First run may fail if files already exist and aren’t symlinks. Remove conflicting files or run `stow --adopt` manually with care.
- Yazi on Debian/Ubuntu: upstream recommends building or using their binary release. The playbook now downloads the latest official binary matching your arch/libc and installs it to `/usr/local/bin`.
- If you prefer to skip installing Yazi (and only stow configs), set `install_yazi: false` in `ansible/playbook.yml`.
- The zsh files in this repo currently include macOS-specific lines; they are harmless when the referenced tools aren’t installed, but adjust as needed for pure Linux.
- To tweak which packages are stowed or where they go, edit `stow_map` in `ansible/playbook.yml`.

Debugging and faster iteration:
- Syntax check: `ansible-playbook ansible/playbook.yml --syntax-check`
- Dry run: `ansible-playbook ansible/playbook.yml --check --diff`
- Verbose: add `-v`, `-vv`, `-vvv`
- Step mode: `--step` to confirm each task
- Only run certain parts via tags:
  - Packages: `--tags packages`
  - Zsh setup: `--tags zsh`
  - Dotfiles clone: `--tags dotfiles`
  - Stowing: `--tags stow`
  - Yazi install: `--tags yazi`
  - Plugins only: `--tags plugins`
- Logs: see `ansible/ansible.log` (auto-created). Output is YAML with task timings.
