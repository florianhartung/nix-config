{ lib, config, ... }:
let
  cfgEnable = config.home.enableAdditionalSupport;
in
{
  options.home.enableAdditionalSupport = lib.mkEnableOption "basic support for home manager";

  config = lib.mkIf cfgEnable {
  };
}
