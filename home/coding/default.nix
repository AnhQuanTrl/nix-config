{
  config,
  options,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    nil
    alejandra
    exercism
  ];

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };
}
