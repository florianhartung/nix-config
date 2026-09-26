{
  modulesPath,
  ...
}:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

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
}
