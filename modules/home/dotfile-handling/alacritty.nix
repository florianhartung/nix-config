{
  lib,
  config,
  ...
}:
{
  options.programs.alacritty.enableSpecialConfigHandling = lib.mkEnableOption "special config handling";
  config = lib.mkIf config.programs.alacritty.enableSpecialConfigHandling {
    programs.alacritty.enable = true;
    xdg.configFile."alacritty/alacritty.toml" = {
      mutableAndBackupDiffs = true;
      force = true;
    };
  };
}
