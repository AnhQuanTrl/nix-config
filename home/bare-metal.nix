{
  inputs,
  dotfilesLib,
  lib,
  config,
  pkgs,
  username,
  outputs,
  ...
}: {
  imports = [
    # ./wm/hyprland.nix
    # ./statusbar/waybar.nix
    ./term/alacritty.nix
    ./editor/nvim.nix
    ./browser/firefox.nix
    ./email/thunderbird.nix
    ./misc/nix-index.nix
    # ./tray
    # ./cursors
    ./coding
  ];

  nixpkgs.overlays = [
    outputs.overlays.additions
  ];

  home = {
    inherit username;
    homeDirectory = "/home/${username}";
  };

  # programs.ags = {
  #   enable = true;
  #   configDir = null;
  #   extraPackages = [pkgs.libsoup_3 pkgs.libdbusmenu-gtk3];
  # };
  # xdg.configFile."ags" = {
  #   source = config.lib.file.mkOutOfStoreSymlink (dotfilesLib.runtimePath ../dotconfig/ags);
  #   recursive = true;
  # };

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
    oh-my-zsh.plugins = ["git"];
    oh-my-zsh.custom = "${customDir}";
    syntaxHighlighting = {
      enable = true;
    };
    enableAutosuggestions = true;
    initExtra = lib.mkOrder 100 ''
      source ~/.p10k.zsh
    '';
    plugins = [
      {
        name = "zsh-vi-mode";
        src = pkgs.fetchFromGitHub {
          owner = "jeffreytse";
          repo = "zsh-vi-mode";
          rev = "v0.11.0";
          sha256 = "sha256-xbchXJTFWeABTwq6h4KWLh+EvydDrDzcY9AQVK65RS8=";
        };
      }
    ];
    # initExtraFirst = ''
    #   if [[ -r "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
    #     source "''${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-''${(%):-%n}.zsh"
    #   fi
    # '';
  };

  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "catppuccin-mocha";
      # themes.catppuccin-mocha = {
      # };
      scrollback_editor = "nvim";
    };
  };

  programs.home-manager.enable = true;
  programs.git.enable = true;
  programs.bash.enable = true;
  # gtk = {
  #   enable = true;
  #   iconTheme = {
  #     package = pkgs.papirus-icon-theme;
  #     name = "Papirus";
  #   };
  # };

  xdg.userDirs.enable = true;
  home.packages = with pkgs; [
    wl-clipboard
    # cliphist
    xdg-user-dirs
    # (eww.override {withWayland = true;})
    (python311.withPackages (p: [p.python-pam]))
    httpie
    # swww
    # inotify-tools
    zx
    # grim
    foliate # book reader
    calibre # book editor
    spot # spotify client
    devbox # for development environment
  ];

  home.sessionVariables = {
    XCURSOR_THEME = "Adwaita";
  };

  services.flatpak.enable = true;
  services.flatpak.packages = [
    {
      appId = "com.usebruno.Bruno";
      origin = "flathub";
    }
  ];

  # home.activation.createScreenshotsDir = let
  #   mkdir = dir: ''$DRY_RUN_CMD mkdir -p $VERBOSE_ARG "${dir}"'';
  # in
  #   lib.hm.dag.entryAfter ["linkGeneration"]
  #   (mkdir "${config.home.homeDirectory}/Pictures/Screenshots");

  home.stateVersion = "23.05";
}
