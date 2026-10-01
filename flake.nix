{
  description = "nixos & home-manager configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # for devshell
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # for NixOS
    impermanence.url = "github:nix-community/impermanence";
    programsdb = {
      url = "github:wamserma/flake-programs-sqlite";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v1.1.0";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # for home manager
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      devshell,
      treefmt-nix,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      project-lib = import ./lib lib;

      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ devshell.overlays.default ];
        config.allowUnfree = true;
      };
      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
      treefmtEval = treefmt-nix.lib.evalModule pkgs ./treefmt.nix;
    in
    {
      nixosConfigurations = {
        desktop = lib.nixosSystem {
          inherit system;
          modules = [
            ./hosts/desktop/configuration.nix
          ];
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
      homeConfigurations = {
        "flo" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./users/flo.nix ];
          extraSpecialArgs = { inherit inputs pkgs-unstable project-lib; };
        };
        "hart_fo" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./users/work.nix ];
          extraSpecialArgs = { inherit inputs pkgs-unstable project-lib; };
        };
      };

      devShells.${system}.default = (
        pkgs.devshell.mkShell {
          name = "dev";

          packages = with pkgs; [
            nixd # Nix LSP
          ];

          imports = [ "${devshell}/extra/git/hooks.nix" ];

          git.hooks = {
            enable = true;
            pre-commit.text = "nix flake check";
          };
        }
      );

      formatter.${system} = treefmtEval.config.build.wrapper;

      checks.${system} = {
        formatting = treefmtEval.config.build.check self;
      };
    };
}
