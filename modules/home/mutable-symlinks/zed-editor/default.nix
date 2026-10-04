{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfgEnable = config.programs.zed-editor.enableMutableSymlinks;
in
{
  options.programs.zed-editor.enableMutableSymlinks = lib.mkEnableOption "config with mutable symlinks";

  config = lib.mkIf cfgEnable {
    assertions = [
      {
        assertion = cfgEnable -> config.mutableSymlinks.enable;
        message = "If enableMutSymlinks is enabled for Zed, it also needs to be enabled globally via 'mutableSymlinks.enable' ";
      }
    ];

    programs.zed-editor.enable = true;
    # xdg.configFile."zed".source = pkgs.mkMutSymlinkFromBuiltInModuleRoot "zed-editor/config";
  };
}
