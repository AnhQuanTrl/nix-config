# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ inputs, config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = final.system;
      };
    })
  ];

  networking.hostName = "orion";

  wsl.enable = true;
  wsl.defaultUser = "betelgeuse";

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  programs.nix-ld.enable = true;
  programs.zsh.enable = true;
  programs.npm.enable = true;

  environment.systemPackages = with pkgs; [
    gcc
    unstable.go
    unzip
    nodejs
    gnumake
    ripgrep
    fd
  ];

   users.defaultUserShell = pkgs.zsh;
  

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?
}
