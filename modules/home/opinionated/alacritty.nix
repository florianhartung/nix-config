{
  pkgs,
  lib,
  config,
  ...
}:
import ./mkEnableWithOpinionatedConfigModule.nix { inherit config lib; } [ "programs" "alacritty" ]
  {
    programs.alacritty.settings = {
      terminal.shell = "${pkgs.zellij}/bin/zellij";
      window.opacity = 0.85;
      font = {
        normal.family = "Jetbrains Mono";
        size = 13;
      };
    };
  }
