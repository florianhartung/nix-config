{
  pkgs,
  lib,
  config,
  ...
}:
import ./mkEnableWithOpinionatedConfigModule.nix { inherit config lib; } [ "programs" "git" ] {
  programs.git.settings = {
    extraConfig = {
      init.defaultBranch = "main";
    };
  };
  home.packages = [ pkgs.git-absorb ];
}
