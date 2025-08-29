{ lib, pkgs, config, inputs, ... }:
let cfg = config.base;
in {
  options.base = { enable = lib.mkEnableOption "base"; };

  config = lib.mkIf cfg.enable {

    # Flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    # Fix command-not-found for flakes <https://blog.nobbz.dev/2023-02-27-nixos-flakes-command-not-found/>
    environment.etc."programs.sqlite".source =
      inputs.programsdb.packages.${pkgs.system}.programs-sqlite;
    programs.command-not-found.dbPath = "/etc/programs.sqlite";

    # TODO this should be the same for all hosts?
    boot.kernelPackages = pkgs.linuxPackages;

    # Bootloader
    # TODO fix this
    # boot.loader.grub = {
    #   enable = true;
    #   useOSProber = true;
    #   efiSupport = true;
    #   # device = "/dev/nvme0n1";
    #   device = "nodev";
    # };

    # Select internationalisation properties.
    time.timeZone = "Europe/Berlin";
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

  };
}
