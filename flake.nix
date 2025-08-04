{
  description = "NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    devshell.url = "github:numtide/devshell";
  };

  outputs = { self, nixpkgs, devshell, ... }@inputs:
    {
      overlays.default = import ./overlays.nix;
    } // (
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          devshell.overlays.default

          # (import ./overlays.nix)
          self.overlays.default
        ];
      };
    in {
      nixosConfigurations = {
        desktop = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/desktop/configuration.nix ];
          specialArgs = { inherit inputs; };
        };
        homebase = lib.nixosSystem {
          inherit system pkgs;
          modules = [ ./hosts/homebase/configuration.nix ];
          specialArgs = { inherit inputs; custom-pkgs = { inherit (pkgs) rustic-rest-server; }; };
        };
      };
      devShells."${system}".default =
        (pkgs.devshell.mkShell { packages = with pkgs; [ nixd nixfmt ]; });
    });
}
