{
  pkgs,
  pkgs-unstable,
  config,
  lib,
  ...
}:
let
  cfg = config.modules.zed;
in
{
  options.modules.zed = {
    enable = lib.mkEnableOption "zed editor";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs-unstable.zed-editor ];

    xdg.configFile."zed".source = pkgs.mkMutSymlink "modules/home/zed/config";
  };
}
