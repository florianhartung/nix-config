{
  pkgs,
  pkgs-2505,
  ...
}:
{
  programs = {
    alacritty.enableMutableSymlinks = true;
    firefox = {
      enableWithOpinionatedConfig = true;
      enableMutableSymlinks = true;
    };
    git = {
      enableWithOpinionatedConfig = true;
      settings.user = {
        name = "Florian Hartung";
        email = "florian.hartung@dlr.de";
      };
    };
    ssh.enableWithOpinionatedConfig = true;
    zed-editor.enableMutableSymlinks = true;
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

  # Welcome to the corner of stuff that is never really touched :D
  imports = [ ../modules/home ];
  home = {
    username = "hart_fo";
    homeDirectory = "/home/hart_fo";
    stateVersion = "23.11"; # Do not ever change this!
  };
}
