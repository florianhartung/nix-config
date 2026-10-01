{ pkgs, ... }:
{
  programs.zellij = {
    enable = true;
    enableFishIntegration = true;
    # settings = {
    #   default_mode = "locked";
    #   theme = "onedark";
    #   pane_frames = false;
    #   default_shell = "fish";
    #   ui = {
    #     pane_frames = {
    #       hide_session_name = true;
    #     };
    #   };
    # };
  };
  home.file = {
    ".config/zellij/config.kdl".source = ./config.kdl;
  };
}
