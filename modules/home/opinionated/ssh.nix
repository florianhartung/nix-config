{
  config,
  lib,
  ...
}:
import ./mkEnableWithOpinionatedConfigModule.nix { inherit config lib; } [ "programs" "ssh" ] {
  programs.ssh = {
    enableDefaultConfig = false;
    settings = {
      "gh" = {
        HostName = "github.com";
        User = "git";
        IdentityFile = "~/.ssh/github";
      };
      "gl" = {
        HostName = "gitlab.com";
        User = "git";
        IdentityFile = "~/.ssh/gitlab";
      };
      "cb" = {
        HostName = "codeberg.org";
        User = "git";
        IdentityFile = "~/.ssh/codeberg";
      };
    };
  };
}
