{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  imports = [ ../modules/home ];

  home.username = "flo";
  home.homeDirectory = "/home/flo";
  home.stateVersion = "25.05"; # shouldn't be changed ever

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
    java.enable = true;
  };

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

  # home.keyboard = {
  #   layout = "us";
  #   variant = "altgr-intl";
  #   options = [ "terminate:ctrl_alt_bksp" "caps:escape" ];
  # };

  xdg.desktopEntries = {
    looking-glass-fix = {
      type = "Application";
      name = "Looking Glass (fix)";
      exec = "__NV_DISABLE_EXPLICIT_SYNC=1 looking-glass-client";
      terminal = false;
      categories = [ "System" ];

      # SingleMainWindow = true;
      # Icon="looking-glass";
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };

  # Workaround: Sometimes gnome-volume-control crashes, which causes this to be set to true.
  home.activation.unset-disable-user-extensions = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${pkgs.dconf}/bin/dconf write /org/gnome/shell/disable-user-extensions false
  '';

  services.easyeffects = {
    enable = true;
  };

  home.packages = with pkgs; [
    vlc
    yubioath-flutter

    ## development
    broot
    nixd

    ## virtualization
    # docker
    wasmedge

    ## utils
    unzip
    btop
    xclip
    nix-search-cli

    ## music
    spotify

    ## gaming
    steam

    # mail
    # thunderbird
    tutanota-desktop
    # protonmail-bridge-gui

    goxel
    pkgs-unstable.prismlauncher
    worldpainter

    quickemu

    keepassxc

    obsidian
    element-desktop
    pinentry-gnome3
    rust-analyzer

    openconnect
    gdb

    keymapp
    valgrind

    pkgs-unstable.zulip # electron on stable is insecure (version is EOL)
    rssguard
    wl-clipboard

    ## network analysis
    # wireshark
    # ettercap

    # element-desktop
    # mattermost
    # citrix_workspace #?
    # thefuck #?
    # openssl #?

    (pkgs.writeShellScriptBin "todo" ''
      ${pkgs.helix}/bin/hx ~/docs/todo.md
    '')
  ];
}
