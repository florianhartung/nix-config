{
  pkgs,
  ...
}:
{
  imports = [
    ./disko.nix
    ../../modules/nixos/proxmox-guest.nix
    ../../modules/nixos
  ];

  networking.hostName = "homelab-services";

  # Nix stuff
  system.stateVersion = "26.05"; # NEVER CHANGE AFTER INITIAL INSTALLATION
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  users.users.root = {
    password = "root";
    packages = with pkgs; [
      helix
      zellij
      git
      direnv

      # man pages
      man-pages
      man-pages-posix
    ];
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
      "/etc/NetworkManager/system-connections"
      "/var/log"
      "/root/.ssh"
    ];
  };

  # Networking (hostname is at the very top)
  services.openssh.enable = true;
  networking.networkmanager.enable = true;

  # man pages
  documentation.dev.enable = true;
}
