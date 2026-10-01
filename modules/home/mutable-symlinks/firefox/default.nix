{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfgEnable = config.programs.firefox.enableMutableSymlinks;
in
{
  options.programs.firefox.enableMutableSymlinks = lib.mkEnableOption "config with mutable firefox";

  config = lib.mkIf cfgEnable {
    assertions = [
      {
        assertion = cfgEnable -> config.mutableSymlinks.enable;
        message = ''
          If enableMutSymlinks is enabled on Firefox, it also needs
          to be enabled globally via 'mutableSymlinks.enable' '';
      }
    ];

    programs.alacritty.enable = true;

    home.file =
      let
        inherit (config.programs.firefox) configPath;
      in
      {
        "${configPath}/default/user.js".source =
          pkgs.mkMutSymlinkFromBuiltInModuleRoot "firefox/config/user.js";
      };
  };
}
