{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.mpd;
  configPath = "${config.xdg.configHome}/mopidy/mopidy.custom.conf";
in {
  options.mpd.spotify = mkOption {
    type = types.bool;
    default = true;
  };

  config = {
    services.mopidy.enable = true;
    services.mopidy.extensionPackages = with pkgs; [
      mopidy-mpd
      mopidy-local
      (mkIf cfg.spotify mopidy-spotify)
    ];
    services.mopidy.extraConfigFiles = [configPath];
    sops.secrets.mopidy = {
      path = configPath;
      sopsFile = ../../dotconfig/mopidy.conf;
      format = "binary";
    };

    programs.ncmpcpp = {
      enable = true;
      package = pkgs.ncmpcpp.override {
        visualizerSupport = true;
      };
      mpdMusicDir = ''''$XDG_MUSIC_DIR'';
      settings = {
        mpd_host = "127.0.0.1";
        mpd_port = "6600";
      };
    };
  };
}
