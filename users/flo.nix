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
    firefox = {
      enableWithOpinionatedConfig = true;
      mutableAndReproducibleSettings = true;
    };
    git = {
      enableWithOpinionatedConfig = true;
      settings.user = {
        name = "Florian Hartung";
        email = "60144801+florianhartung@users.noreply.github.com";
      };
    };
    ssh.enableWithOpinionatedConfig = true;
    zed-editor = {
      enableWithOpinionatedConfig = true;
      mutableAndReproducibleUserSettings = true;
    };

    # other stuff
    gpg.enable = true;
  };

  # TODO: merge into programs
  modules = {
    discord.enable = true;
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
    element-desktop
    keepassxc
    obsidian
    openconnect
    prismlauncher
    pkgs-unstable.zulip # electron is insecure on stable (version is EOL)
    quickemu
    rssguard
    spotify
    steam
    vlc
    yubioath-flutter
    pkgs-2505.citrix_workspace
  ];

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gnome3;
    };
    easyeffects.enable = true;
  };

  # This is the directory where those diffs of mutable dotfiles will go, before
  # they are overwritten during home activation.
  mutableReproducibleConfig.backupDirectoryForDiffs = "${config.xdg.configHome}/home-manager/modules/home/backup-diffs/";

  # Welcome to the corner of stuff that is never really touched :D
  imports = [ ../modules/home ];
  home = {
    username = "flo";
    homeDirectory = "/home/flo";
    stateVersion = "25.05"; # Do not ever change this!
  };
}
