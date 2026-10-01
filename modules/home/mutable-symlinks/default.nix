{ config, lib, ... }:
let
  cfg = config.mutableSymlinks;
  inherit (lib)
    types
    mkOption
    mkIf
    ;
in
{
  imports = [
    ./alacritty
    ./firefox
    ./zed-editor
  ];

  options.mutableSymlinks = {
    enable = mkOption {
      description = ''
        Whether to enable mutable symlinks for configuration files. This
        installs an overlay into nixpkgs, providing the `mkMutSymlink*`
        functions.

        By itself, this module does nothing else. The 'enableMutSymlinks' must
        be set on supported 'programs.*' modules.
      '';
      default = true;
      type = types.bool;
    };
    repositoryBasePath = mkOption {
      description = "This repository's root path. This is required so that evaluation can remain pure.";
      default = "${config.xdg.configHome}/home-manager"; # TODO incorrect if xdg is not enabled
      type = types.str;
    };
  };

  config = mkIf cfg.enable (
    let
      mkMutSymlinkFrom =
        basePath: relativeFilePath: config.lib.file.mkOutOfStoreSymlink "${basePath}/${relativeFilePath}";
    in
    {
      nixpkgs.overlays = [
        (final: prev: {
          mkMutSymlinkFromRepositoryRoot = mkMutSymlinkFrom cfg.repositoryBasePath;
          mkMutSymlinkFromBuiltInModuleRoot = mkMutSymlinkFrom "${cfg.repositoryBasePath}/modules/home/mutable-symlinks";
        })
      ];
    }
  );
}
