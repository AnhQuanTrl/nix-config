{
  inputs,
  pkgs,
  config,
  dotfilesLib,
  ...
}: {
  config = {
    nixpkgs.overlays = [
      (final: prev: {
        neovim = inputs.neovim.packages.${final.system}.default.override {
          inherit ((builtins.getFlake "github:NixOS/nixpkgs/d4758c3f27804693ebb6ddce2e9f6624b3371b08").legacyPackages.${final.system}) libvterm-neovim;
        };
      })
    ];

    home.packages = [pkgs.neovim];

    xdg.configFile."nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink (dotfilesLib.runtimePath ../../dotconfig/nvim);
      recursive = true;
    };
  };
}
