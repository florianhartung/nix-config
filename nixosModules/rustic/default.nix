{  pkgs, lib, config, ... }:
let
  cfg = config.services.rustic.server;
in {
  options.services.rustic.server = lib.mkOption {
    enable = lib.mkEnableOption "Rustic REST Server";

    package = lib.mkPackageOption pkgs "rustic-rest-server" { };
  };

  config = lib.mkIf cfg.enable {
    
  };
}
