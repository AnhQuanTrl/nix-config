{
  config,
  options,
  pkgs,
  lib,
  ...
}: {
  config = {
    wayland.windowManager.hyprland = {
      enable = true;
      systemd.enable = true;
      settings = {
        "$mod" = "SUPER";
        "$term" = "alacritty";
        monitor = [
          "eDP-1,1920x1200@60,2560x0,1"
          "DP-1,2560x1440@60,0x0,1"
        ];
        exec-once = [
          "systemctl --user stop pipewire wireplumber"
          "systemctl --user start pipewire wireplumber"
          "sleep 10 && swww init"
          "wl-paste --type text --watch cliphist store"
          "wl-paste --type image --watch cliphist store"
          "hyprctl setcursor ${config.home.pointerCursor.name} 24"
        ];
        exec = [
          "swww img $HOME/Pictures/wallpaper.jpg"
        ];
        input = {
          kb_options = "ctrl:nocaps";
          touchpad = {
            natural_scroll = true;
          };
        };
        windowrule = let
          f = regex: "float, ^(${regex})$";
        in [
        ];

        bind = [
          # App
          "$mod, RETURN, exec, $term"

          # Window Management
          "$mod, Q, killactive"
          "$mod, E, exit"

          # Focus
          "$mod, h, movefocus, l"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, l, movefocus, r"

          # Move window
          "$mod SHIFT, h, movewindow, l"
          "$mod SHIFT, j, movewindow, d"
          "$mod SHIFT, k, movewindow, u"
          "$mod SHIFT, l, movewindow, r"

          # Switch workspaces
          "$mod, 1, workspace, 1"
          "$mod, 2, workspace, 2"
          "$mod, 3, workspace, 3"
          "$mod, 4, workspace, 4"
          "$mod, 5, workspace, 5"
          "$mod, 6, workspace, 6"
          "$mod, 7, workspace, 7"
          "$mod, 8, workspace, 8"
          "$mod, 9, workspace, 9"
          "$mod, 0, workspace, 10"

          # Move active window to workspace
          "$mod SHIFT, 1, movetoworkspace, 1"
          "$mod SHIFT, 2, movetoworkspace, 2"
          "$mod SHIFT, 3, movetoworkspace, 3"
          "$mod SHIFT, 4, movetoworkspace, 4"
          "$mod SHIFT, 5, movetoworkspace, 5"
          "$mod SHIFT, 6, movetoworkspace, 6"
          "$mod SHIFT, 7, movetoworkspace, 7"
          "$mod SHIFT, 8, movetoworkspace, 8"
          "$mod SHIFT, 9, movetoworkspace, 9"
          "$mod SHIFT, 0, movetoworkspace, 10"

          # Screen capture
          "$mod, p, exec, grim $(xdg-user-dir PICTURES)/Screenshots/$(date +'%s_grim.png')"
        ];
      };
    };

    # services.kanshi = {
    #   enable = true;
    #   profiles = {
    #     undocked = {
    #       outputs = [
    #         {
    #           criteria = "eDP-1";
    #           status = "enable";
    #         }
    #       ];
    #     };
    #     home_office = {
    #       outputs = [
    #         {
    #           criteria = "Dell Inc. DELL P2723D 44L4PW3";
    #           position = "0,0";
    #           mode = "2560x1440@60Hz";
    #           scale = 1.0;
    #         }
    #         {
    #           criteria = "eDP-1";
    #           status = "disable";
    #         }
    #       ];
    #     };
    #   };
    #   systemdTarget = "hyprland-session.target";
    # };
  };
}
