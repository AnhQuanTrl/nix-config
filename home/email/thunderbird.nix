{
  inputs,
  pkgs,
  config,
  dotfilesLib,
  ...
}: {
  config = {
    home.file."thunderbird-gnome-theme" = {
      target = ".thunderbird/default/chrome/thunderbird-gnome-theme";
      source = fetchTarball {
        url = "https://github.com/rafaelmardojai/thunderbird-gnome-theme/archive/master.tar.gz";
        sha256 = "sha256:0msyi9aar6f2ciw8w8bymvx03zfdx67qasac2v0i1sc9py3sivib";
      };
    };

    programs.thunderbird = {
      enable = true;
      profiles = {
        default = {
          userChrome = ''
            @import "thunderbird-gnome-theme/userChrome.css";
          '';
          userContent = ''
            @import "thunderbird-gnome-theme/userContent.css";
          '';
          isDefault = true;
          settings = {
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # Enable customChrome.cs
            "svg.context-properties.content.enabled" = true; # Enable SVG context-propertes
          };
        };
      };
    };
  };
}
