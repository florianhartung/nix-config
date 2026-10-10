{
  pkgs,
  config,
  lib,
  ...
}:
let
  cfg = config.programs.ov;
in
{
  options.programs.ov = {
    enable = lib.mkEnableOption "ov - a terminal pager";
    package = lib.mkPackageOption pkgs "ov" {
      nullable = true;
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf (cfg.package != null) [ cfg.package ];
  };
}
