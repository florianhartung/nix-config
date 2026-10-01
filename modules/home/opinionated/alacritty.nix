{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfgEnable = config.programs.alacritty.enableOpinionatedConfig;
in
{
  options.programs.alacritty.enableOpinionatedConfig = lib.mkEnableOption "opinionated config for alacritty";

  config = lib.mkIf cfgEnable {
    programs.alacritty = {
      enable = true;
      settings = {
        terminal.shell = "${pkgs.zellij}/bin/zellij";
        window.opacity = 0.85;
        font = {
          normal.family = "Jetbrains Mono";
          size = 13;
        };
      };
    };
  };
}
