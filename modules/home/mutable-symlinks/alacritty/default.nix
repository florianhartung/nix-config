{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfgEnable = config.programs.alacritty.enableMutableSymlinks;
in
{
  options.programs.alacritty.enableMutableSymlinks = lib.mkEnableOption "config with mutable symlinks";

  config = lib.mkIf cfgEnable {
    assertions = [
      {
        assertion = cfgEnable -> config.mutableSymlinks.enable;
        message = ''
          If enableMutSymlinks is enabled on Alacritty, it also needs
                              to be enabled globally via 'mutableSymlinks.enable' '';
      }
    ];

    programs.alacritty.enable = true;
    xdg.configFile."alacritty/alacritty.toml".source =
      pkgs.mkMutSymlinkFromBuiltInModuleRoot "alacritty/config.toml";
  };
}
