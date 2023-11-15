{pkgs, ...}:
with pkgs; {
  devShells = {
    neovim = mkShell {
      NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
        stdenv.cc.cc
      ];
      NIX_LD = lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker";
    };
  };
}
