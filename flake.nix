{
  description = "Oskar's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, niri, ... }: {
    nixosConfigurations = {
      # VM on macOS (aarch64)
      vm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./hosts/vm/configuration.nix
          ./modules/common.nix
          home-manager.nixosModules.home-manager
          niri.nixosModules.niri
        ];
      };

      # AMD64 machine
      amd64-machine = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/amd64-machine/configuration.nix
          ./modules/common.nix
          home-manager.nixosModules.home-manager
          niri.nixosModules.niri
        ];
      };
    };
  };
}
