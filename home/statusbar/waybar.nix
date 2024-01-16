{
  config,
  options,
  pkgs,
  lib,
  ...
}: {
  config = {
    programs.waybar = {
      enable = true;

      settings = {
        mainBar = {
          layer = "top";
          height = 30;
          spacing = 4;
          modules-left = ["hyprland/workspaces"];
          modules-right = ["pulseaudio" "network" "cpu" "memory" "clock" "tray"];
          "hyprland/workspaces" = {
            format = "{icon}";
            on-click = "activate";
            format-icons = {
              urgent = "";
              active = "";
              default = "";
            };
            sort-by-numbers = true;
          };
          "tray" = {
            spacing = 10;
          };
          "clock" = {
            format = "{:%I:%M %p}";
            tooltip-format = "<tt><small>{calendar}</small></tt>";
            format-alt = "{:%Y-%m-%d}";
            calendar = {
              format = {
                months = "<big><b>{}</b></big>";
              };
            };
          };
          "cpu" = {
            format = "{usage}% <span font='14'>󰻠</span>";
          };
          "memory" = {
            format = "{}% <span font='14'>󰍛</span>";
          };
          "network" = {
            format-wifi = "{essid} ({signalStrength}%) <span font='14'>󰖩</span>";
            format-ethernet = "Connected <span font='14'>󰈁</span>";
            tooltip-format = "{ifname} via {gwaddr}/{cidr}";
            format-linked = "{ifname} (No IP) <span font='14'>󰈁</span>";
            format-disconnected = "Disconnected <span font='14'>󰈂</span>";
            format-alt = "{ipaddr}";
          };
          "pulseaudio" = {
            format = "{volume}% <span font='14'>{icon}</span>";
            format-bluetooth = "{volume}% <span font='14'>{icon}</span>";
            format-bluetooth-muted = "󰖁";
            format-muted = "󰖁";
            format-icons = {
              headphone = "";
              hands-free = "󰋎";
              headset = "󰋎";
              phone = "";
              portable = "";
              car = "";
              default = ["" "" ""];
            };
          };
        };
      };
      style = let
        base = "#1e1e2e";
        overlay0 = "#6c7086";
        mauve = "#cba6f7";
        teal = "#94e2d5";
        red = "#f38ba8";
        yellow = "#f9e2af";
        subtext1 = "#bac2de";
        sapphire = "#74c7ec";
        text = "#cdd6f4";
        peach = "#fab387";
      in ''
        * {
          font-family: 'FiraCode Nerd Font';
          font-size: 14px;
        }

        window#waybar {
          background-color: rgba(30, 30, 46, 0.5);
          color: ${base};
          transition-property: background-color;
          transition-duration: .5s;
          border-bottom: none;
        }

        window#waybar.hidden {
          opacity: 0.2;
        }

        button {
          box-shadow: inset 0 -3px transparent;
          border: none;
          border-radius: 0;
        }

        button:hover {
          background: ${overlay0};
          box-shadow: inset 0 -3px ${overlay0};
        }

        #workspaces button {
          padding: 0 5px;
          background-color: transparent;
          color: ${mauve};
        }

        #workspaces button:hover {
          background: rgba(108, 112, 134, 0.2);
        }

        #workspaces button.active {
          background-color: ${base};
          box-shadow: inset 0 -3px ${teal};
        }

        #workspaces button.urgent {
          background-color: ${red};
        }

        tooltip {
          color: ${text};
          background: rgba(30, 30, 46, 1);
          border: 3px solid ${teal};
        }

        #clock,
        #cpu,
        #memory,
        #network,
        #pulseaudio,
        #tray {
          min-width: 100px;
          padding: 0 10px;
          color: ${base};
          border-radius: 0;
        }

        #windo,
        #tray w,
        #workspaces {
          margin: 0 4px;
        }

        .modules-left > widget:first-child > #workspaces {
          margin-left: 0;
        }

        .modules-left > widget:last-child > #workspaces {
          margin-right: 0;
        }

        #clock {
          color: ${base};
          background-color: ${red};
        }

        #cpu {
          color: ${base};
          background-color: ${teal};
        }

        #memory {
          color: ${base};
          background-color: ${mauve};
        }

        #network {
          color: ${base};
          background-color: ${sapphire};
        }

        #network.disconnected {
          background-color: ${subtext1};
        }

        #pulseaudio {
          color: ${base};
          background-color: ${yellow};
        }

        #pulseaudio.muted {
          color: ${base};
          background-color: ${subtext1};
        }

        #tray {
          color: ${base};
          background-color: ${peach};
        }

        #tray > .passive {
          -gtk-icon-effect: dim;
        }

        #tray > .needs-attention {
          -gtk-icon-effect: highlight;
          background-color: ${red};
        }
      '';
    };
  };
}
