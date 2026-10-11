{
  lib,
  config,
  ...
}:
import ../mkEnableWithOpinionatedConfigModule.nix { inherit config lib; } [ "programs" "ov" ] {
  xdg.configFile."ov/config.yaml".source = ./config.yaml;
}
