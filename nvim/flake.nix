{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };
  outputs = { self, nixpkgs, flake-parts, ... } @ inputs: flake-parts.lib.mkFlake { inherit inputs; }
  {
    systems = [
      "x86_64-linux"
    ];
    
    perSystem = { pkgs, system, ... }:
    {
      devShells.default = with pkgs; mkShell {
        NIX_LD_LIBRARY_PATH = lib.makeLibraryPath [
          stdenv.cc.cc	  
        ];
        NIX_LD = lib.fileContents "${stdenv.cc}/nix-support/dynamic-linker";
      };
    };
  };
}
