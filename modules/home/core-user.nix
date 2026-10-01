{
  config,
  ...
}:
{
  # Home manager can manage itself
  programs.home-manager.enable = true;

  # For working on the configuration
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;
  programs.git.enable = true;
  home.shellAliases = {
    hswitch = "home-manager switch";
  };

  # IDK
  nixpkgs.config.allowUnfree = true;

  # Clean XDG dirs! Why not?
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;

      documents = "${config.home.homeDirectory}/docs";
      download = "${config.home.homeDirectory}/downloads";
      desktop = null;
      music = null;
      pictures = null;
      templates = null;
      videos = null;
      publicShare = null;
    };
  };
}
