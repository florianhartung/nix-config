{
  pkgs,
  ...
}:
{
  networking = {
    firewall.allowedTCPPorts = [ 8384 ]; # syncthing gui
    hostName = "homelab-services";
  };

  services = {
    openssh.enable = true;
    syncthing = {
      enable = true;
      openDefaultPorts = true;
      guiAddress = "0.0.0.0:8384";
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
