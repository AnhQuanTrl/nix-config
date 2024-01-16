{
  config,
  options,
  pkgs,
  lib,
  ...
}: {
  home.pointerCursor = {
    package = pkgs.my-catppuccin-cursors;
    name = "Catppuccin-Mocha-Mauve-Cursors";
    size = 24;
    gtk.enable = true;
  };
}
