{
  description = "NixOS Flake";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";

    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, devshell, ... }@inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [ devshell.overlays.default ];
      };
    in {
      nixosConfigurations = {
        desktop = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/desktop/configuration.nix ];
          specialArgs = { inherit inputs; };
        };
        homebase = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/homebase/configuration.nix ];
          specialArgs = { inherit inputs; };
        };
        nixos-nas = lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/nixos-nas/configuration.nix ];
        };
      };
      devShells."${system}".default =
        (pkgs.devshell.mkShell { packages = with pkgs; [ nixd nixfmt ]; });
    };
}
