# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ lib, config, pkgs, inputs, ... }:

{
  imports = [
    inputs.lanzaboote.nixosModules.lanzaboote
    ./hardware-configuration.nix
    ../../nixosModules
  ];

  base.enable = true;

  impermanence = {
    enable = true;
    devPath = "/dev/nvme0n1p5";
    files = [
      "/etc/machine-id"
      # "/var/lib/NetworkManager/secret_key"
      # "/var/lib/NetworkManager/seen-bssids"
      # "/var/lib/NetworkManager/timestamps"
    ];
    directories = [
      "/etc/nixos"
      "/var/lib/nixos"
      "/var/lib/libvirt"
      "/etc/NetworkManager/system-connections"
      "/var/log"
      "/root/.ssh"
      "/var/lib/sbctl"
      # "/var/lib/bluetooth"
    ];
  };

  fileSystems."/".options = [ "compress=zstd" "noatime" ];
  fileSystems."/home".options = [ "compress=zstd" "noatime" ];
  fileSystems."/nix".options = [ "compress=zstd" "noatime" ];
  fileSystems."/persist".options = [ "compress=zstd" "noatime" ];
  # fileSystems."/boot".options =  [ "umask=0077" ];

  # fileSystems."/run/media/flo/backup-device" = {
  #   device = "/dev/disk/by-uuid/F60EF4830EF43E65";
  #   fsType = "ntfs";
  #   options = [ "nofail" "users" ];
  # };

  # Bootloader.
  boot.lanzaboote = {
    enable = false;
    pkiBundle = "/var/lib/sbctl";
  };

  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ntfs-3g" ];
  boot.loader.systemd-boot.enable = lib.mkForce false;
  boot.loader.grub = {
    enable = true;
    useOSProber = true;
    efiSupport = true;
    # device = "/dev/nvme0n1";
    device = "nodev";
  };

  # boot.initrd.kernelModules = ["i915"];

  services.pcscd.enable = true;

  networking.hostName = "desktop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  # time.timeZone = "Europe/Berlin";
  # Necessary for dual boot
  time.hardwareClockInLocalTime = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";

  # i18n.extraLocaleSettings = {
  #   LC_ADDRESS = "de_DE.UTF-8";
  #   LC_IDENTIFICATION = "de_DE.UTF-8";
  #   LC_MEASUREMENT = "de_DE.UTF-8";
  #   LC_MONETARY = "de_DE.UTF-8";
  #   LC_NAME = "de_DE.UTF-8";
  #   LC_NUMERIC = "de_DE.UTF-8";
  #   LC_PAPER = "de_DE.UTF-8";
  #   LC_TELEPHONE = "de_DE.UTF-8";
  #   LC_TIME = "de_DE.UTF-8";
  # };

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;

    # Configure keymap in X11
    # layout = "us";
    # xkbVariant = "altgr-intl";
  };
  # services.displayManager.ly.enable = true;
  programs.hyprland.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.flo = {
    isNormalUser = true;
    description = "Florian Hartung";
    extraGroups = [ "audio" "networkmanager" "libvirtd" "kvm" ];
    shell = pkgs.fish;
    hashedPasswordFile = "/persist/passwords/flo";
  };

  users.users.root = {
    shell = pkgs.fish;
    hashedPasswordFile = "/persist/passwords/root";
    packages = with pkgs; [ helix zellij git direnv ];
  };

  programs.fish.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  fonts.fontconfig.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # for logitech mouse
    solaar
    logitech-udev-rules
    swtpm
    looking-glass-client
    virt-manager

  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  #   helix
  #   kitty
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?


  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # hardware.graphics.enable = true;
  hardware.nvidia = {
    open = false;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false; # for multi-gpu setups?
  };
  services.xserver.videoDrivers = [ "nvidia" ];

  programs.steam = {
    enable = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
    localNetworkGameTransfers.openFirewall = true;
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "performance";
    cpufreq.min = 1600000;
  };

  # virtualisiation
  programs.virt-manager.enable = true;
  # users.groups.libvirtd.members = [ "flo" ];
  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "start";
      qemu = {
        # package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          # packages = [(pkgs.OVMF.override {
          #   secureBoot = true;
          #   tpmSupport = true;
          # }).fd];
          packages = [ pkgs.OVMFFull.fd ];
        };
      };
    };
    # tpm.enable = true;
    spiceUSBRedirection.enable = true;
  };

  # PCI/GPU passthrough
  # boot.initrd.kernelModules = [
  #   "vfio_pci"
  #   "vfio"
  #   "vfio_iommu_type1"

  #   "i915"
  # ];
  # boot.kernelParams = [
  #   "intel_iommu=on"
  #   "vfio-pci.ids=10de:1e84,10de:10f8,10de:1ad8,10de:1ad9"
  # ];
  # systemd.tmpfiles.rules = [
  #   "f /dev/shm/looking-glass 0660 flo qemu-libvirtd -"
  # ];
  
}
