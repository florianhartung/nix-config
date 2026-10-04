{
  lib,
  config,
  ...
}:
let
  cfgEnable = config.programs.zed-editor.enableSpecialConfigHandling;
in
{
  options.programs.zed-editor.enableSpecialConfigHandling = lib.mkEnableOption "special config handling";

  config = lib.mkIf cfgEnable {
    programs.zed-editor = {
      enable = true;
      mutableUserSettings = false;
    };

    xdg.configFile."zed/settings.json" = {
      mutableAndBackupDiffs = true;
      force = true;
    };
  };
}
