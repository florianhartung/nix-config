{
  pkgs,
  pkgs-unstable,
  lib,
  ...
}:
{
  home.username = "flo";
  home.homeDirectory = "/home/flo";
  home.stateVersion = "25.05"; # shouldn't be changed ever

  nixpkgs.config.allowUnfree = true;

  # programs.kitty.enable = true;

  # home.keyboard = {
  #   layout = "us";
  #   variant = "altgr-intl";
  #   options = [ "terminate:ctrl_alt_bksp" "caps:escape" ];
  # };

  imports = [ ../modules/home ];

  home.shellAliases = {
    cdg = "cd ~/git";
    cdm = "cd ~/git/florianhartung";
    hswitch = "home-manager switch";
  };

  modules = {
    base.enable = true;
    # This lets other modules symlink their configs from this repo into the home
    # directory, while leaving them mutable.
    mutSymlink.enable = true;

    alacritty.enable = true;
    discord.enable = true;
    firefox.enable = true;
    fonts.enable = true;
    gde-stuff = {
      enable = true;
      mouse-speed = 0.58;
    };
    vscodium.enable = true;
    zed.enable = true;
  };

  xdg.enable = true;
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
  programs.gpg = {
    enable = true;
  };

  programs.java.enable = true;

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
