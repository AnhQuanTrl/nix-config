{
  description = "NixOS WSL Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-wsl, home-manager, nix-index-database, flake-utils, sops-nix, ... } @ inputs:
    let
      systems = [ "x86_64-linux" ];
      lib = nixpkgs.lib;
      dotfilesLib = {
      	runtimePath = runtimeRoot: path:
        let
          rootStr = toString self;
          pathStr = toString path;
        in assert lib.assertMsg (lib.hasPrefix rootStr pathStr)
                "${pathStr} does not start with ${rootStr}";
        runtimeRoot + lib.removePrefix rootStr pathStr;
      };
      nixosSystem = modules: nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
        };
        inherit modules;
      };
      homeManagerConfiguration = modules: home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {
          inherit inputs;
          inherit system;
          inherit dotfilesLib;
        };
        inherit modules;
      };
    in {
      nixosConfigurations = {
        orion = nixosSystem [ nixos-wsl.nixosModules.wsl ./hosts/orion ];
        lyra = nixosSystem [ hosts/lyra ];
      };

      homeConfigurations = {
        "betelgeuse@orion" = homeManagerConfiguration [
      	    nix-index-database.hmModules.nix-index
            sops-nix.homeManagerModules.sops
	    ./home.nix
	];
        "vega@lyra" = homeManagerConfiguration [
          nix-index-database.hmModules.nix-index
          sops-nix.homeManagerModules.sops
	  ./home.nix
        ];
      };
    } // flake-utils.lib.eachSystem systems (system: import ./shells nixpkgs.legacyPackages.${system});
}
