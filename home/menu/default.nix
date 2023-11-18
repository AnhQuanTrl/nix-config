{
  config,
  options,
  pkgs,
  lib,
  ...
}: let
  cfg = config.menu;
in {
  config = {
    programs.rofi = {
      enable = true;
      font = "FiraCode Nerd Font";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      plugins = [pkgs.rofi-emoji];
      extraConfig = {
        show-icons = true;
        modi = "drun,run,window,emoji";
        display-drun = "";
        display-run = "";
        display-window = "";
        sidebar-mode = true;
      };
    };
    xsession.windowManager.i3.config.menu = "--no-startup-id rofi -show run";
  };
}
