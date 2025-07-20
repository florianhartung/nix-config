# TODO
# - put setup guide somewhere
# - commands for adding persistence for a file/directory. e.g. `cp -r {,/persist}/etc/nixos`
# - command as shortcut for fs-diff.sh
# - groups for commonly persisted files/directories. e.g. "bluetooth", "network", "ssh", "varlog"

{ lib, config, inputs, ... }:
let cfg = config.impermanence;
in {

  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.impermanence = {
    enable = lib.mkEnableOption "impermanence";
    devPath = lib.mkOption {
      description = ''
        a device containing the btrfs filesystem according to the impermanence guide
      '';
      type = lib.types.str;
      example = "/dev/nvme0n1p5";
    };
  };

  config = lib.mkIf cfg.enable {
    fileSystems."/persist".neededForBoot = true;

    environment.persistence."/persist" = {
      directories = [
        "/etc/nixos"
        "/var/lib/nixos"
        "/etc/NetworkManager/system-connections"
        "/var/log"
        "/root/.ssh"
        # "/var/lib/bluetooth"
      ];
      files = [
        "/etc/machine-id"
        # "/var/lib/NetworkManager/secret_key"
        # "/var/lib/NetworkManager/seen-bssids"
        # "/var/lib/NetworkManager/timestamps"
      ];
    };

    security.sudo.extraConfig = ''
      # rollback results in sudo lectures after each reboot
      Defaults lecture = never
    '';

    boot.initrd = {
      enable = true;
      supportedFilesystems = [ "btrfs" ];

      postResumeCommands = lib.mkAfter ''
        mkdir -p /mnt
        # We first mount the btrfs root to /mnt
        # so we can manipulate btrfs subvolumes.
        mount -o subvol=/ ${cfg.devPath} /mnt

        # While we're tempted to just delete /root and create
        # a new snapshot from /root-blank, /root is already
        # populated at this point with a number of subvolumes,
        # which makes `btrfs subvolume delete` fail.
        # So, we remove them first.
        #
        # /root contains subvolumes:
        # - /root/var/lib/portables
        # - /root/var/lib/machines
        #
        # I suspect these are related to systemd-nspawn, but
        # since I don't use it I'm not 100% sure.
        # Anyhow, deleting these subvolumes hasn't resulted
        # in any issues so far, except for fairly
        # benign-looking errors from systemd-tmpfiles.
        btrfs subvolume list -o /mnt/root |
        cut -f9 -d' ' |
        while read subvolume; do
          echo "deleting /$subvolume subvolume..."
          btrfs subvolume delete "/mnt/$subvolume"
        done &&
        echo "deleting /root subvolume..." &&
        btrfs subvolume delete /mnt/root

        echo "restoring blank /root subvolume..."
        btrfs subvolume snapshot /mnt/root-blank /mnt/root

        # Once we're done rolling back to a blank snapshot,
        # we can unmount /mnt and continue on the boot process.
        umount /mnt
      '';
    };

  };
}
