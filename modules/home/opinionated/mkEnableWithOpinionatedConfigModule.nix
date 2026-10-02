{
  lib,
  config,
}:
module: opinionatedConfig:
let
  enableModule = (lib.setAttrByPath (module ++ [ "enable" ]) true);
  fullConfig = lib.recursiveUpdate enableModule opinionatedConfig;
in
{
  options = lib.setAttrByPath (module ++ [ "enableWithOpinionatedConfig" ]) (
    lib.mkEnableOption "opinionated config"
  );
  config = lib.mkIf (lib.getAttrFromPath (
    module ++ [ "enableWithOpinionatedConfig" ]
  ) config) fullConfig;
}
