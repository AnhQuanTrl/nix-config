{
  inputs,
  dotfilesLib,
  lib,
  config,
  pkgs,
  username,
  ...
}: {
  home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };

  nixpkgs.overlays = [
    (final: prev: {
      neovim = inputs.neovim.packages.${final.system}.default.override {
        inherit ((builtins.getFlake "github:NixOS/nixpkgs/d4758c3f27804693ebb6ddce2e9f6624b3371b08").legacyPackages.${final.system}) libvterm-neovim;
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
      phases = ["buildPhase"];
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
    oh-my-zsh.plugins = ["git" "git-commit"];
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
      "bitbucket.org" = {
        hostname = "bitbucket.org";
        identityFile = "~/.ssh/bitbucket";
      };
    };
  };
  programs.alacritty = {
    enable = true;
  };

  xsession.enable = true;
  xsession.scriptPath = ".xsession-hm";
  xsession.profilePath = ".xprofile-hm";
  xsession.windowManager.i3 = {
    enable = true;
    config = let
      modifier = "Mod4";
      up = "k";
      down = "j";
      left = "h";
      right = "l";
      terminal = "alacritty";
    in {
      inherit modifier;
      inherit terminal;
      keybindings = {
        "${modifier}+Return" = "exec ${terminal}";
        "${modifier}+Shift+q" = "kill";
        "${modifier}+d" = "exec ${config.xsession.windowManager.i3.config.modifier}";

        "${modifier}+Left" = "focus left";
        "${modifier}+Down" = "focus down";
        "${modifier}+Up" = "focus up";
        "${modifier}+Right" = "focus right";

        "${modifier}+${left}" = "focus left";
        "${modifier}+${down}" = "focus down";
        "${modifier}+${up}" = "focus up";
        "${modifier}+${right}" = "focus right";

        "${modifier}+Shift+Left" = "move left";
        "${modifier}+Shift+Down" = "move down";
        "${modifier}+Shift+Up" = "move up";
        "${modifier}+Shift+Right" = "move right";

        "${modifier}+Shift+${left}" = "move left";
        "${modifier}+Shift+${down}" = "move down";
        "${modifier}+Shift+${up}" = "move up";
        "${modifier}+Shift+${right}" = "move right";

        "${modifier}+x" = "split h";
        "${modifier}+v" = "split v";
        "${modifier}+f" = "fullscreen toggle";

        "${modifier}+s" = "layout stacking";
        "${modifier}+w" = "layout tabbed";
        "${modifier}+e" = "layout toggle split";

        "${modifier}+Shift+space" = "floating toggle";
        "${modifier}+space" = "focus mode_toggle";

        "${modifier}+a" = "focus parent";

        "${modifier}+Shift+minus" = "move scratchpad";
        "${modifier}+minus" = "scratchpad show";

        "${modifier}+1" = "workspace number 1";
        "${modifier}+2" = "workspace number 2";
        "${modifier}+3" = "workspace number 3";
        "${modifier}+4" = "workspace number 4";
        "${modifier}+5" = "workspace number 5";
        "${modifier}+6" = "workspace number 6";
        "${modifier}+7" = "workspace number 7";
        "${modifier}+8" = "workspace number 8";
        "${modifier}+9" = "workspace number 9";
        "${modifier}+0" = "workspace number 10";

        "${modifier}+Shift+1" = "move container to workspace number 1";
        "${modifier}+Shift+2" = "move container to workspace number 2";
        "${modifier}+Shift+3" = "move container to workspace number 3";
        "${modifier}+Shift+4" = "move container to workspace number 4";
        "${modifier}+Shift+5" = "move container to workspace number 5";
        "${modifier}+Shift+6" = "move container to workspace number 6";
        "${modifier}+Shift+7" = "move container to workspace number 7";
        "${modifier}+Shift+8" = "move container to workspace number 8";
        "${modifier}+Shift+9" = "move container to workspace number 9";
        "${modifier}+Shift+0" = "move container to workspace number 10";

        "${modifier}+Shift+c" = "reload";
        "${modifier}+Shift+r" = "restart";
        "${modifier}+Shift+e" = "exec i3-nagbar -t warning -m 'Do you want to exit i3?' -b 'Yes' 'i3-msg exit'";

        "${modifier}+r" = "mode resize";
      };
    };
  };

  xresources.properties = {
    "Xft.dpi" = 144;
  };

  sops = {
    age.keyFile = "${config.xdg.configHome}/sops/age/keys.txt";
    secrets = {
      ssh_github = {
        path = "${config.home.homeDirectory}/.ssh/github";
        sopsFile = ../secrets/ssh/github;
        format = "binary";
      };
      ssh_bitbucket = {
        path = "${config.home.homeDirectory}/.ssh/bitbucket";
        sopsFile = ../secrets/ssh/bitbucket;
        format = "binary";
      };
    };
  };

  home.packages = [
    pkgs.neovim
  ];

  home.file.".p10k.sh".source = config.lib.file.mkOutOfStoreSymlink (dotfilesLib.runtimePath ../.p10k.sh);
  home.file."./.ssh/github.pub".source = config.lib.file.mkOutOfStoreSymlink (dotfilesLib.runtimePath ../secrets/ssh/github.pub);
  home.file."./.ssh/bitbucket.pub".source = config.lib.file.mkOutOfStoreSymlink (dotfilesLib.runtimePath ../secrets/ssh/bitbucket.pub);

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink (dotfilesLib.runtimePath ../nvim);
    recursive = true;
  };

  home.stateVersion = "23.05";
}
