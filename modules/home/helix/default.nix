{ pkgs, ... }:
{
  home.packages = [ pkgs.helix ];

  home.file = {
    ".config/helix/config.toml".source = ./config.toml;
    ".config/helix/languages.toml".source = ./languages.toml;
  };
  programs.helix = {
    enable = true;
    defaultEditor = true;
  };
}
