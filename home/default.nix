{ inputs, dotfilesLib, lib, config, pkgs, system, ... }: {
  home = {
    username = "betelgeuse";
    homeDirectory = "/home/betelgeuse";
  };

  nixpkgs.overlays = [
    (final: prev : {
      neovim = inputs.neovim.packages.${system}.default.override {
        inherit ((builtins.getFlake "github:NixOS/nixpkgs/d4758c3f27804693ebb6ddce2e9f6624b3371b08").legacyPackages.${system}) libvterm-neovim;
      };
    })
  ];

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    extraConfig = {
      pull.rebase = false;
    };
  };
  programs.bash.enable = true;
  programs.nix-index = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
  };
  programs.zsh = let
    p10k-theme = pkgs.fetchFromGitHub {
      owner = "romkatv";
      repo = "powerlevel10k";
      rev = "v1.19.0";
      hash = "sha256-+hzjSbbrXr0w1rGHm6m2oZ6pfmD6UUDBfPd7uMg5l5c=";
    };
    customDir = pkgs.stdenv.mkDerivation {
      name = "oh-my-zsh-custom-dir";
      phases = [ "buildPhase" ];
      buildPhase = ''
        mkdir -p $out/themes/powerlevel10k
        cp -r ${p10k-theme}/. $out/themes/powerlevel10k/
      '';
    };
    in {
      enable = true;
      enableCompletion = true;
      oh-my-zsh.enable = true;
      oh-my-zsh.theme = "powerlevel10k/powerlevel10k";
      oh-my-zsh.plugins = [ "git" "git-commit" ];
      oh-my-zsh.custom = "${customDir}";
      enableSyntaxHighlighting = true;
      enableAutosuggestions = true;
      initExtra = ''
        source ~/.p10k.sh
      '';
      initExtraFirst = ''
        if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi
      '';
    };
  programs.ssh = {
    enable = true;
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        identityFile = "~/.ssh/github";
      };
    };
  };

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    secrets = {
      ssh_github = {
        path = "${config.home.homeDirectory}/.ssh/github";
        sopsFile = ./secrets/ssh/github;
        format = "binary";
      };
    };
  };

  home.packages = [
    pkgs.neovim
  ];

  home.file.".p10k.sh".source = config.lib.file.mkOutOfStoreSymlink (dotfilesLib.runtimePath "${config.home.homeDirectory}/nix-config" ./.p10k.sh);
  home.file."./.ssh/github.pub".source = config.lib.file.mkOutOfStoreSymlink (dotfilesLib.runtimePath "${config.home.homeDirectory}/nix-config" ./secrets/ssh/github.pub);

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink (dotfilesLib.runtimePath /home/betelgeuse/nix-config ./nvim);
    recursive = true;
  };

  home.stateVersion = "23.05";
}

