# Bare-Metal Systems (NixOS)

1. Boot into NixOS ISO

# Proxmox VMs (NixOS)

1.  Create a new VM. Most default settings suffice.

    > [!NOTE]
    > The SCSI Controller must be set to some of the VirtIO options. Others do not work!

2.  Make sure to use SeaBIOS as the BIOS for now.
3.  Load a NixOS installer ISO.
4.  Boot into the NixOS installer.
5.  Enable the ssh daemon: `sudo systemctl start sshd`
6.  Set a temporary password for root via `sudo -i` and then `passwd`.
7.  Install NixOS with nixos-anywhere via SSH:
    ```sh
    nix run github:nix-community/nixos-anywhere -- --flake .#HOSTNAME --phases kexec,disko,install --target-host root@HOST_IP
    ```
8.  Over SSH or through Proxmox console, copy files and directories to persist
    like so:
    ```bash
    FILES_TO_PERSIST=(/etc/machine-id /etc/nixos /var/lib/nixos /var/log)
    for f in "${FILES_TO_PERSIST[@]}"; do
      cp --no-target-directory --recursive $f /mnt/persist/$f
    done
    ```
9.  Remove the NixOS installer ISO.
10. Set the BIOS to OVMF (UEFI) and create an EFI disk.
11. Enable the QEMU Guest Agent in Options.
12. Boot into the VM and disable Secure Boot.

# Users (using Home Manager)

- Root user: Included in the NixOS installation by default (using a NixOS
  module).
- Normal users:
  1. Refer to the Home Manager Manual (Section "Nix Flakes" > "Standalone Setup").
  2. Clone this repository into `~/.config/home-manager`. You can "clone" a git
     repository with `GIT_URL` into an existing non-empty directory by adding it
     as a remote (as long as there are no conflicts):

     ```sh
     git init .
     git branch -M main
     git remote add origin GIT_URL
     git fetch origin
     git reset origin/main
     ```
