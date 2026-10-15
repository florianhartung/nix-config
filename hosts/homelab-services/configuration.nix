{
  config,
  pkgs,
  lib,
  ...
}:
{
  networking = {
    firewall.allowedTCPPorts = [ 8384 ]; # syncthing gui
    hostName = "homelab-services";
  };

  services = {
    openssh = {
      enable = true;
      settings.PasswordAuthentication = true;
      settings.PermitRootLogin = "yes";
    };
    syncthing = {
      enable = false;
      openDefaultPorts = true;
      guiAddress = "0.0.0.0:8384";
    };
    hytale-server = {
      enable = true;
      serverJar = "/var/lib/hytale-server/Server/HytaleServer.jar";
      assetsZip = "/var/lib/hytale-server/Assets.zip";
      jvmOpts = "-Xms13G -Xmx13G";
    };
  };
  programs.screen = {
    enable = true;
    screenrc = ''
      multiuser on
    '';
  };

  users.users.hytale.isSystemUser = lib.mkForce false;
  users.users.hytale.isNormalUser = lib.mkForce true;
  systemd.services.hytale-server = {
    preStart = lib.mkForce ""; # I moved the Assets.zip/HytaleServer.jar files into the correct places already.
    serviceConfig = {
        Sockets = "foo.socket";
        StandardInput = "socket";
        StandardOutput = "journal";
        StandardError = "journal";
    };
  };
  systemd.sockets.foo = {
    name = "foo.socket";
    socketConfig = {
      ListenFIFO = "%t/foo.stdin";
      Service = "hytale-server.service";
    };
  };

  impermanence = {
    enable = true;
    devPath = "/dev/sda2";
    files = [
      "/etc/machine-id"
    ];
    directories = [
      "/etc/nixos"
      "/var/lib/nixos"
      "/var/log"
      "/var/lib/syncthing"
      "/var/lib/hytale-server"
    ];
  };

  users.users.root = {
    password = "root";
    packages = with pkgs; [
      helix
      zellij
      git
      direnv
    ];

  };

  # Welcome to the corner of stuff that is never really touched :D
  imports = [
    ./disko.nix
    ../../modules/nixos/proxmox-guest.nix
    ../../modules/nixos
  ];
  system.stateVersion = "26.05"; # NEVER CHANGE AFTER INITIAL INSTALLATION
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
}
