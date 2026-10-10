{
  pkgs,
  lib,
  config,
  ...
}:
import ./mkEnableWithOpinionatedConfigModule.nix { inherit config lib; } [ "programs" "git" ] {
  programs = {
    git.settings = {
      # `main`, not `master`
      init = {
        defaultBranch = "main";
      };

      # `ov` as pager
      core = {
        pager = "ov --quit-if-one-screen";
      };
      pager = {
        diff = "ov --quit-if-one-screen --section-delimiter '^diff' --section-header";
        log = "ov --quit-if-one-screen --section-delimiter '^commit' --section-header-num 3";
        show = "ov --quit-if-one-screen --header 3";
      };
    };
    ov.enable = true;
  };
  home.packages = with pkgs; [ git-absorb ];
}
