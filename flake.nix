{
  description = "Oskar's NixOS configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };

    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, niri, zen-browser, ... }: {
    nixosConfigurations = {
      # VM on macOS (aarch64)
      vm = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
	specialArgs = { inherit zen-browser; };
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
	specialArgs = { inherit zen-browser; };
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
