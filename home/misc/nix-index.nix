{
  config,
  options,
  pkgs,
  lib,
  ...
}: {
  config = {
    programs.nix-index = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };
  };
}
