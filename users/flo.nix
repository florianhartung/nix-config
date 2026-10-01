{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  programs = {
    alacritty.enableMutableSymlinks = true;
    git = {
      enableOpinionatedConfig = true;
      settings.user = {
        name = "Florian Hartung";
        email = lib.mkDefault "60144801+florianhartung@users.noreply.github.com";
      };
    };
    zed-editor.enableMutableSymlinks = true;

    # other stuff
    gpg.enable = true;
  };

  # todo merge into programs
  modules = {
    discord.enable = true;
    firefox.enable = true;
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
    pkgs-unstable.zulip # unstable: electron on stable is insecure (version is EOL)
    quickemu
    rssguard
    spotify
    steam
    vlc
    yubioath-flutter
  ];

  services = {
    gpg-agent = {
      enable = true;
      enableSshSupport = true;
      pinentry.package = pkgs.pinentry-gnome3;
    };
    easyeffects.enable = true;
  };

  # Welcome to the corner of stuff that is never really touched :D
  imports = [ ../modules/home ];
  home = {
    username = "flo";
    homeDirectory = "/home/flo";
    stateVersion = "25.05"; # Do not ever change this!
  };
}
