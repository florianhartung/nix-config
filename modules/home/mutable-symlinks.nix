{ config, lib, ... }:
let
  cfg = config.modules.mutSymlink;
  inherit (lib)
    types
    mkOption
    mkIf
    ;
in
{
  options.modules.mutSymlink = {
    enable = mkOption {
      description = ''
        Whether to enable mutable symlinked files. This installs an overlay into
        nixpkgs, providing the `mkMutSymlink` function. This function allows to
        create an out-of-store mutable symlink to a file in this repository in
        the final home directory.
      '';
      default = false;
      example = true;
      type = types.bool;
    };
    repositoryBasePath = mkOption {
      description = "This repository's root path. This is required so that no impure evaluation is needed.";
      default = "${config.xdg.configHome}/home-manager"; # TODO incorrect if xdg is not enabled
      type = types.str;
    };
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (final: prev: {
        mkMutSymlink = file: (config.lib.file.mkOutOfStoreSymlink "${cfg.repositoryBasePath}/${file}");
      })
    ];
  };
}
