{
  inputs,
  pkgs,
  config,
  dotfilesLib,
  ...
}: {
  config = {
    home.file."firefox-gnome-theme" = {
      target = ".mozilla/firefox/default/chrome/firefox-gnome-theme";
      source = fetchTarball {
        url = "https://github.com/rafaelmardojai/firefox-gnome-theme/archive/master.tar.gz";
        sha256 = "sha256:1n6q7xkflwj243dal3kxmjv4hrizbh4p93jwbny7ivqf346p92j9";
      };
    };

    programs.firefox = {
      enable = true;
      profiles = {
        default = {
          userChrome = ''
            @import "firefox-gnome-theme/userChrome.css";
          '';
          userContent = ''
            @import "firefox-gnome-theme/userContent.css";
          '';
          id = 0;
          name = "default";
          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable customChrome.cs
            "svg.context-properties.content.enabled" = true; # Enable SVG context-propertes
            "browser.uidensity" = 0;
            "browser.theme.dark-private-windows" = false;
            "widget.gtk.rounded-bottom-corners.enabled" = true;
          };
        };
      };
    };

    home.sessionVariables = {
      MOZ_ENABLE_WAYLAND = "1";
    };
  };
}
