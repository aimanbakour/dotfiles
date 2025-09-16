{
  description = "VPS dev env";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    system = "x86_64-linux";
    pkgsFor = system: import nixpkgs {inherit system;};
  in {
    # Home-Manager config for root
    homeConfigurations.root = home-manager.lib.homeManagerConfiguration {
      pkgs = pkgsFor system;
      modules = [
        {
          home.username = "root";
          home.homeDirectory = "/root";
          home.stateVersion = "24.05";
        }

        ({pkgs, ...}: {
          home.packages = with pkgs; [
            zsh
            tmux
            neovim
            git
            ripgrep
            fd
            htop
            zoxide
            fzf
            jq
            file
            yazi
            ffmpeg
            p7zip
            poppler_utils
            resvg
            imagemagick
            nerd-fonts.jetbrains-mono
            xclip
          ];

          home.file = {
            # from THIS repo next to flake.nix
            ".config/zsh/.zshrc".source = ../zsh/.zshrc;
            ".config/zsh/.zprofile".source = ../zsh/.zprofile;
            ".config/tmux/.tmux.conf".source = ../tmux/tmux.conf;
            ".config/nvim".source = ../nvim;

            ".zshrc".text = ''
              export ZDOTDIR="$HOME/.config/zsh"
              source "$ZDOTDIR/.zshrc"
            '';
            ".zprofile".text = ''
              export ZDOTDIR="$HOME/.config/zsh"
              source "$ZDOTDIR/.zprofile"
            '';

            "Downloads/.keep".text = "";
            "Developer/.keep".text = "";
            ".local/scripts/.keep".text = "";
          };
        })
      ];
    };
    homeConfigurations.current = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {system = "x86_64-linux";}; # or "aarch64-linux"
      modules = [
        # infer the logged-in user/home at eval-time (requires --impure)
        (let
          user = let
            u = builtins.getEnv "USER";
          in
            if u == ""
            then "aiman"
            else u;
          home = let
            h = builtins.getEnv "HOME";
          in
            if h == ""
            then "/home/${user}"
            else h;
        in {
          home.username = user;
          home.homeDirectory = home;
          home.stateVersion = "24.05";
        })

        # SAME payload you use under `root` (packages + files), just keep the ../ paths
        ({pkgs, ...}: {
          home.packages = with pkgs; [
            zsh
            tmux
            neovim
            git
            ripgrep
            fd
            htop
            zoxide
            fzf
            jq
            file
            yazi
            ffmpeg
            p7zip
            poppler_utils
            resvg
            imagemagick
            nerd-fonts.jetbrains-mono
            xclip
          ];
          home.file = {
            ".config/zsh/.zshrc".source = ../zsh/.zshrc;
            ".config/zsh/.zprofile".source = ../zsh/.zprofile;
            ".config/tmux/.tmux.conf".source = ../tmux/tmux.conf;
            ".config/nvim".source = ../nvim;
            ".zshrc".text = ''
              export ZDOTDIR="$HOME/.config/zsh"
              source "$ZDOTDIR/.zshrc"
            '';
            ".zprofile".text = ''
              export ZDOTDIR="$HOME/.config/zsh"
              source "$ZDOTDIR/.zprofile"
            '';
            "Downloads/.keep".text = "";
            "Developer/.keep".text = "";
            ".local/scripts/.keep".text = "";
          };
        })
      ];
    };

    # One command: applies the root config
    apps.${system}.switch = {
      type = "app";
      program = let
        pkgs = pkgsFor system;
        hm = home-manager.packages.${system}.home-manager;
        bin = pkgs.writeShellApplication {
          name = "switch";
          runtimeInputs = [hm];
          text = ''
            set -euo pipefail
            home-manager switch --flake ${self}#root "$@"
          '';
        };
      in "${bin}/bin/switch";
    };
  };
}
