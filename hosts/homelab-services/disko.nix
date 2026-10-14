{ lib, ... }:
let
  mountOptions = [
    "compress=zstd"
    "noatime"
  ];
  btrfsSubvolumeNames = [
    "home"
    "nix"
  ];

  makeSubvolume = name: {
    "${name}" = {
      inherit mountOptions;
      mountpoint = "/${name}";
    };
  };
  subvolumes = lib.attrsets.mergeAttrsList (map makeSubvolume btrfsSubvolumeNames);
in
{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/sda";
    content = {
      type = "gpt";
      partitions = {
        ESP = {
          priority = 1;
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = [
              "fmask=0077"
              "umask=0077"
            ];
          };
        };
        root = {
          size = "100%";
          content = {
            type = "btrfs";
            subvolumes = {
              "root" = {
                inherit mountOptions;
                mountpoint = "/";
              };
              "persist" = {
                inherit mountOptions;
                mountpoint = "/persist";
              };
              "swap" = {
                mountpoint = "/.swapvol";
                swap = {
                  swapfile.size = "2GB";
                };
              };
            }
            // subvolumes;
          };
        };
      };
    };
  };
}
