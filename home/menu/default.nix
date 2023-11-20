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
      font = "FiraCode Nerd Font 14";
      terminal = "${pkgs.alacritty}/bin/alacritty";
      plugins = [pkgs.rofi-emoji];
      theme = let
        inherit (config.lib.formats.rasi) mkLiteral;
      in {
        "*" = {
          "bg-col" = mkLiteral "#1e1e2e";
          "bg-col-light" = mkLiteral "#1e1e2e";
          "border-col" = mkLiteral "#1e1e2e";
          "selected-col" = mkLiteral "#1e1e2e";
          "blue" = mkLiteral "#89b4fa";
          "fg-col" = mkLiteral "#cdd6f4";
          "fg-col2" = mkLiteral "#f38ba8";
          "grey" = mkLiteral "#6c7086";

          width = 600;
        };
        "element-text, element-icon, mode-switcher" = {
          background-color = mkLiteral "inherit";
          text-color = mkLiteral "inherit";
        };
        "window" = {
          height = mkLiteral "360px";
          border = mkLiteral "3px";
          border-color = mkLiteral "@border-col";
          background-color = mkLiteral "@bg-col";
        };
        "mainbox" = {
          background-color = mkLiteral "@bg-col";
        };
        "inputbar" = {
          children = map mkLiteral ["prompt" "entry"];
          background-color = mkLiteral "@bg-col";
          border-radius = mkLiteral "5px";
          padding = mkLiteral "2px";
        };
        "prompt" = {
          background-color = mkLiteral "@blue";
          padding = mkLiteral "6px";
          text-color = mkLiteral "@bg-col";
          border-radius = mkLiteral "3px";
          margin = mkLiteral "20px 0px 0px 20px";
        };

        "textbox-prompt-colon" = {
          expand = mkLiteral "false";
          str = ":";
        };

        "entry" = {
          padding = mkLiteral "6px";
          margin = mkLiteral "20px 0px 0px 10px";
          text-color = mkLiteral "@fg-col";
          background-color = mkLiteral "@bg-col";
        };

        "listview" = {
          border = mkLiteral "0px 0px 0px";
          padding = mkLiteral "6px 0px 0px";
          margin = mkLiteral "10px 0px 0px 20px";
          columns = 2;
          lines = 5;
          background-color = mkLiteral "@bg-col";
        };

        "element" = {
          padding = mkLiteral "5px";
          background-color = mkLiteral "@bg-col";
          text-color = mkLiteral "@fg-col  ";
        };

        "element-icon" = {
          size = mkLiteral "25px";
        };

        "element selected" = {
          background-color = mkLiteral " @selected-col ";
          text-color = mkLiteral "@fg-col2  ";
        };

        "mode-switcher" = {
          spacing = 0;
        };

        "button" = {
          padding = mkLiteral "10px";
          background-color = mkLiteral "@bg-col-light";
          text-color = mkLiteral "@grey";
          vertical-align = mkLiteral "0.5";
          horizontal-align = mkLiteral "0.5";
        };

        "button selected" = {
          background-color = mkLiteral "@bg-col";
          text-color = mkLiteral "@blue";
        };

        "message" = {
          background-color = mkLiteral "@bg-col-light";
          margin = mkLiteral "2px";
          padding = mkLiteral "2px";
          border-radius = mkLiteral "5px";
        };

        "textbox" = {
          padding = mkLiteral "6px";
          margin = mkLiteral "20px 0px 0px 20px";
          text-color = mkLiteral "@blue";
          background-color = mkLiteral "@bg-col-light";
        };
      };
      extraConfig = {
        show-icons = true;
        icon-theme = "Papirus";
        modi = "drun,run,window";
        # display-drun = "";
        # display-run = "";
        # display-window = "";
        display-drun = " 󰀘  Apps ";
        display-run = "   Run ";
        display-window = " 󰕰  Window ";
        drun-display-format = "{icon} {name}";
        sidebar-mode = true;
      };
    };
    xsession.windowManager.i3.config.menu = "--no-startup-id rofi -show drun";
  };
}
