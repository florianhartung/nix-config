{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfgEnable = config.programs.git.enableOpinionatedConfig;
in
{
  options.programs.git.enableOpinionatedConfig = lib.mkEnableOption "opinionated config for git";

  config = lib.mkIf cfgEnable {
    programs.git = {
      settings = {
        extraConfig = {
          init.defaultBranch = "main";
        };
      };
    };
    home.packages = [ pkgs.git-absorb ];
  };
}
