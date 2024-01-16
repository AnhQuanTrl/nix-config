{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.statusbar;
in {
  options.statusbar.mpd = mkOption {
    type = types.bool;
    default = true;
    description = ''
      Whether to show mpd module on statusbar.
    '';
  };

  config = {
    services.polybar = let
      theme = pkgs.fetchFromGitHub {
        owner = "catppuccin";
        repo = "polybar";
        rev = "main";
        hash = "sha256-bUbSgMg/sa2faeEUZo80GNmhOX3wn2jLzfA9neF8ERA=";
      };
    in {
      enable = true;
      package = pkgs.polybar.override {
        i3Support = true;
        pulseSupport = true;
        mpdSupport = true;
      };
      settings = {
        "global/wm" = {
          include-file = "${theme}/themes/mocha.ini";
        };
        "bar/mybar" = {
          font = [
            "FiraCode Nerd Font:style=Bold:size=12;3"
            "FiraCode Nerd Font:size=14;3"
          ];
          bottom = false;
          width = "100%";
          height = 25;
          radius = 0;
          background = ''''${colors.mantle}'';
          foreground = ''''${colors.text}'';
          padding-left = 1;
          padding-right = 1;
          border-top-size = 5;
          border-bottom-size = 5;
          line-size = 1;
          border-top-color = ''''${colors.mantle}'';
          border-bottom-color = ''''${colors.mantle}'';

          modules-left = "round-left workspaces round-right ${
            if cfg.mpd
            then "empty-space mpd"
            else ""
          }";
          modules-right = "audio empty-space network empty-space cpu empty-space memory empty-space battery empty-space round-left time round-right";
        };
        "module/workspaces" = {
          type = "internal/xworkspaces";
          format = "<label-state>";
          pin-workspaces = false;
          format-background = ''''${colors.surface0}'';

          label-active = "󰝥";
          label-active-padding = 1;

          label-occupied = "󰝦";
          label-occupied-padding = 1;

          label-urgent = "󰝥";
          label-urgent-foreground = ''''${colors.red}'';
          label-urgent-padding = 1;
        };
        "module/round-left" = {
          type = "custom/text";
          content = "";
          content-foreground = ''''${colors.surface0}'';
          content-font = 2;
        };
        "module/round-right" = {
          type = "custom/text";
          content = "";
          content-foreground = ''''${colors.surface0}'';
          content-font = 2;
        };
        "module/empty-space" = {
          type = "custom/text";
          content = "   ";
        };
        "module/audio" = {
          type = "internal/pulseaudio";
          format.volume.text = "<ramp-volume> <label-volume>";
          label.muted.text = "󰖁 0%";
          ramp.volume = ["󰕿" "󰖀" "󰕾"];
          label.volume.foreground = ''''${colors.blue}'';
          format.volume.foreground = ''''${colors.blue}'';
          label.muted.foreground = ''''${colors.text}'';
          click.right = "${pkgs.lxqt.pavucontrol-qt}/bin/pavucontrol-qt &";
        };
        "module/time" = {
          type = "internal/date";
          interval = 60;
          format = "<label>";
          format-background = ''''${colors.surface0}'';
          format-foreground = ''''${colors.subtext1}'';
          label = "%date%%time%";
          label-padding = 1;

          date = "󰥔 %I:%M %p";
          time-alt = "󰃭 %a, %b %d";
        };
        "module/cpu" = {
          type = "internal/cpu";
          interval = 2;
          format-prefix = "  ";
          format = "<label>";
          label = "%{A1:${pkgs.st}/bin/st -e ${pkgs.btop}/bin/btop:}CPU %percentage%%%{A}";
          format-foreground = ''''${colors.mauve}'';
        };
        "module/memory" = {
          type = "internal/memory";
          internal = 2;
          format-prefix = "󰘚 ";
          format = "<label>";
          label = "%{A1:${pkgs.st}/bin/st -e ${pkgs.btop}/bin/btop:}%mb_used%%{A}";
          format-prefix-foreground = ''''${colors.peach}'';
        };
        "module/network" = {
          type = "internal/network";
          interface = "enp0s3";
          interval = 2;
          format-connected = "<label-connected>";
          label-connected = "%{A1:${pkgs.networkmanagerapplet}/bin/nm-connection-editor:}󰤢 %upspeed% 󰯎 %downspeed%%{A}";
          label-connected-foreground = ''''${colors.teal}'';
          label-disconnected = "%{A1:${pkgs.networkmanagerapplet}/bin/nm-connection-editor:}󰤠 %{A}";
          label-disconnected-foreground = ''''${colors.red}'';
        };
        "module/battery" = {
          type = "internal/battery";
          battery = "BAT0";
          adapter = "AC";
          poll-interval = 10;
          format-charging = "<animation-charging> <label-charging>";
          label-charging = "%percentage%%";

          format-discharging = "<ramp-capacity> <label-discharging>";
          label-discharging = "%percentage%%";

          format-full-prefix = "  ";
          format-full-prefix-foreground = ''''${colors.green}'';

          ramp-capacity-0 = " ";
          ramp-capacity-1 = " ";
          ramp-capacity-2 = " ";
          ramp-capacity-3 = " ";
          ramp-capacity-4 = " ";
          ramp-capacity-foreground = ''''${colors.text}'';
          ramp-capacity-0-foreground = ''''${colors.red}'';
          ramp-capacity-1-foreground = ''''${colors.yellow}'';

          animation-charging-0 = " ";
          animation-charging-1 = " ";
          animation-charging-2 = " ";
          animation-charging-3 = " ";
          animation-charging-4 = " ";

          animation-charging-foreground = ''''${colors.green}'';
          animation-charging-framerate = 750;
        };
        "module/mpd" = mkIf cfg.mpd {
          type = "internal/mpd";
          host = "127.0.0.1";
          port = "6600";
          interval = 2;
          label-song = "%{A1:${pkgs.mpc-cli}/bin/mpc toggle:}%{A3:${pkgs.alacritty}/bin/alacritty -e ${pkgs.ncmpcpp}/bin/ncmpcpp:}%{A4:${pkgs.mpc-cli}/bin/mpc next:}%{A5:${pkgs.mpc-cli}/bin/mpc prev:} %artist% - %title% %{A}%{A}%{A}%{A}";
          format-playing = "󰎈 <label-song>";
          format-paused = "󰎊 <label-song>";
          format-stopped = "";
          format-playing-foreground = ''''${colors.mauve}'';
          format-paused-foreground = ''''${colors.text}'';
        };
      };
      script = ''polybar mybar &'';
    };
  };
}
