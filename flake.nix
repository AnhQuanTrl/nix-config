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
  };
    
  outputs = { self, nixpkgs, nixos-wsl, home-manager, nix-index-database, flake-utils, ... } @ inputs:
    let
      systems = [ "x86_64-linux" ];
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = nixpkgs.legacyPackages.${system};
      dotfilesLib = {
      	runtimePath = runtimeRoot: path:
	  let
	    rootStr = toString self;
	    pathStr = toString path;
	  in assert lib.assertMsg (lib.hasPrefix rootStr pathStr)
            "${pathStr} does not start with ${rootStr}";
	  runtimeRoot + lib.removePrefix rootStr pathStr;
      };
    in {
      nixosConfigurations = {
        orion = nixpkgs.lib.nixosSystem {
          inherit system;
                    
          modules = [ 
            nixos-wsl.nixosModules.wsl
            ./wsl.nix
          ];
        
          specialArgs = {
            inherit inputs;
          };
        };        
      };

      homeConfigurations = {
        "betelgeuse@orion" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;

          modules = [
	    nix-index-database.hmModules.nix-index
	    ./home.nix 
	  ];
	  extraSpecialArgs = {
            inherit inputs;
            inherit system;
	    inherit dotfilesLib;
          };
        };
      };
    } // flake-utils.lib.eachSystem systems (system: import ./shells nixpkgs.legacyPackages.${system});
}
