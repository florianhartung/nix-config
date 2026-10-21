{
  config,
  pkgs,
  pkgs-2505,
  pkgs-unstable,
  ...
}:
{
  programs = {
    alacritty = {
      enableWithOpinionatedConfig = true;
      mutableAndReproducibleSettings = true;
    };
    bat = {
      enable = true;
      config.pager = "ov --quit-if-one-screen";
    };
    firefox = {
      enableWithOpinionatedConfig = true;
      mutableAndReproducibleSettings = true;
    };
    fish.enableWithOpinionatedConfig = true;
    git = {
      enableWithOpinionatedConfig = true;
      settings.user = {
        name = "Florian Hartung";
        email = "florian.hartung@dlr.de";
      };
    };
    ov = {
      enableWithOpinionatedConfig = true;
      package = pkgs-unstable.ov;
    };
    ssh.enableWithOpinionatedConfig = true;
    gram = {
      enableWithOpinionatedConfig = true;
      mutableAndReproducibleUserSettings = true;
    };
  };

  # TODO: merge into programs
  modules = {
    fonts.enable = true;
    gde-stuff = {
      enable = true;
      mouse-speed = 0.58;
    };
    vscodium.enable = true;
  };

  home.packages = with pkgs; [
    # terminal
    broot
    wl-clipboard
    btop
    unzip

    # programs
    dconf-editor
    element-desktop
    jabref
    mattermost-desktop
    obsidian
    pkgs-2505.citrix_workspace # # BROKEN,INSECURE: on 26.05
    thunderbird
    yubioath-flutter

    # language servers
    ltex-ls
    nixd
  ];

  home.sessionVariables = {
    ELECTRON_OZONE_PLATFORM_HINT = "wayland"; # for vscodium
  };

  # This is the directory where those diffs of mutable dotfiles will go, before
  # they are overwritten during home activation.
  mutableReproducibleConfig.backupDirectoryForDiffs = "${config.xdg.configHome}/home-manager/modules/home/backup-diffs/";

  # Welcome to the corner of stuff that is never really touched :D
  imports = [ ../modules/home ];
  home = {
    username = "hart_fo";
    homeDirectory = "/home/hart_fo";
    stateVersion = "23.11"; # Do not ever change this!
  };
}
