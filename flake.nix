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

  outputs = {
    self,
    nixpkgs,
    nixos-wsl,
    home-manager,
    nix-index-database,
    flake-utils,
    sops-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;
    systems = ["x86_64-linux"];
    lib = nixpkgs.lib;
    dotfilesLib = username: {
      runtimePath = path: let
        rootStr = toString self;
        pathStr = toString path;
      in
        assert lib.assertMsg (lib.hasPrefix rootStr pathStr)
        "${pathStr} does not start with ${rootStr}";
          "/home/${username}/nix-config" + lib.removePrefix rootStr pathStr;
    };
    nixosSystem = modules:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          inherit outputs;
        };
        inherit modules;
      };
    homeManagerConfiguration = username: modules:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = {
          inherit inputs;
          dotfilesLib = dotfilesLib username;
          inherit username;
        };
        inherit modules;
      };
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in
    {
      overlays = import ./overlays {inherit inputs;};
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
      nixosConfigurations = {
        orion = nixosSystem [nixos-wsl.nixosModules.wsl ./hosts/orion];
        lyra = nixosSystem [hosts/lyra];
      };

      homeConfigurations = {
        "betelgeuse@orion" = homeManagerConfiguration "beltelgeuse" [
          nix-index-database.hmModules.nix-index
          sops-nix.homeManagerModules.sops
          ./home
        ];
        "vega@lyra" = homeManagerConfiguration "vega" [
          nix-index-database.hmModules.nix-index
          sops-nix.homeManagerModules.sops
          ./home
        ];
      };
    }
    // flake-utils.lib.eachSystem systems (system: import ./shells nixpkgs.legacyPackages.${system});
}
