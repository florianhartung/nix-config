{
  lib,
  config,
  ...
}:
import ./mkEnableWithOpinionatedConfigModule.nix { inherit config lib; } [ "programs" "fish" ] {
  # These also work in POSIX shells
  home.shellAliases = {
    cdd = "cd -- $(git rev-parse --show-cdup)";
    hswitch = "home-manager switch";
  };
}
