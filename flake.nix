{
  description = "NixOS WSL Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
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
    nix-flatpak.url = "github:gmodena/nix-flatpak";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    nixos-wsl,
    home-manager,
    nix-index-database,
    flake-utils,
    sops-nix,
    nix-flatpak,
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
          inherit outputs;
        };
        inherit modules;
      };
    forAllSystems = nixpkgs.lib.genAttrs systems;
  in
    {
      overlays = import ./overlays {inherit inputs;};
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.alejandra);
      nixosConfigurations = {
        orion = nixosSystem [nixos-wsl.nixosModules.wsl ./hosts/orion];
        lyra = nixosSystem [hosts/lyra];
        canis-major = nixosSystem [./hosts/canis-major nixos-hardware.nixosModules.lenovo-thinkpad-t14];
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
        "sirius@canis-major" = homeManagerConfiguration "sirius" [
          nix-flatpak.homeManagerModules.nix-flatpak
          ./home/bare-metal.nix
        ];
      };
    }
    // flake-utils.lib.eachSystem systems (system: import ./shells nixpkgs.legacyPackages.${system});
}
