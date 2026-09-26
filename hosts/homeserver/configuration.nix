{
  modulesPath,
  pkgs,
  ...
}:
{
  imports = [
    # TODO enable ./hardware-configuration.nix
    # TODO add modules
    ./disko.nix

    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  networking.hostName = "homeserver";

  # Bootloader
  boot.loader = {
    # Proxmox stores EFI vars on a separate inaccessible disk.
    efi.canTouchEfiVariables = false;

    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      # Because we cannot access the EFI vars for Proxmox VMs, this installs the
      # bootloader at the location `/EFI/boot/boot$arch.efi`, which is hardcoded
      # in firmwares such as OVMF.
      efiInstallAsRemovable = true;
    };
  };

  # Nix stuff
  system.stateVersion = "26.05"; # NEVER CHANGE AFTER INITIAL INSTALLATION
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Root user
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

  # Networking (hostname is at the very top)
  services.openssh.enable = true;
  networking.networkmanager.enable = true;

  # man pages
  documentation.dev.enable = true;
}
