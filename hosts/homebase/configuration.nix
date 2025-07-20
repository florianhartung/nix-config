# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../nixosModules
  ];

  impermanence = {
    enable = true;
    devPath = "/dev/nvme0n1p3";

    directories = [
      "/etc/nixos"
      "/var/lib/nixos"
      "/var/lib/docker"
      "/etc/NetworkManager/system-connections"
      "/var/systemd/coredump"
      "/var/systemd/timers"
      "/var/log"
      "/root/.ssh"
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"

      # "/var/lib/NetworkManager/secret_key"
      # "/var/lib/NetworkManager/seen-bssids"
      # "/var/lib/NetworkManager/timestamps"
    ];
  };

  fileSystems."/".options = [ "compress=zstd" "noatime" ];
  fileSystems."/home".options = [ "compress=zstd" "noatime" ];
  fileSystems."/nix".options = [ "compress=zstd" "noatime" ];
  fileSystems."/persist".options = [ "compress=zstd" "noatime" ];
  fileSystems."/boot".options = [ "umask=0077" ];


  # fileSystems."/run/media/flo/backup-device" = {
    # device = "/dev/disk/by-uuid/F60EF4830EF43E65";
    # fsType = "ntfs";
    # options = [ "nofail" "users" ];
  # };

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
    efiSupport = true;
    # device = "/dev/nvme0n1";
    device = "nodev";
  };

  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelPackages = pkgs.linuxPackages;
  # boot.supportedFilesystems = [ "ntfs-3g" ];
  # boot.initrd.kernelModules = ["i915"];


  # Fix command-not-found for flakes <https://blog.nobbz.dev/2023-02-27-nixos-flakes-command-not-found/>
  environment.etc."programs.sqlite".source = inputs.programsdb.packages.${pkgs.system}.programs-sqlite;
  programs.command-not-found.dbPath = "/etc/programs.sqlite";

  networking.hostName = "homebase"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  virtualisation.docker = {
    enable = true;
    storageDriver = "btrfs";
  };



  # Set your time zone.
  time.timeZone = "Europe/Berlin";
  # Necessary for dual boot
  # time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # services.displayManager.ly.enable = true;
  # programs.hyprland.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  # security.rtkit.enable = true;
  # services.pipewire = {
    # enable = true;
    # alsa.enable = true;
    # alsa.support32Bit = true;
    # pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    flo = {
      isNormalUser = true;
      extraGroups = [ "docker" "wheel" ];
      shell = pkgs.fish;
      hashedPasswordFile = "/persist/passwords/flo";
    };

    root = {
      hashedPasswordFile = "/persist/passwords/root";
      shell = pkgs.fish;
      packages = with pkgs; [ helix zellij git direnv ];
    };
  };

  programs.fish.enable = true;

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # hardware.graphics.enable = true;
  # services.xserver.videoDrivers = [ "modesetting" ];
}
