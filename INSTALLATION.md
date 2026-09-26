# Bare-Metal Systems (NixOS)

1. Boot into NixOS ISO

# Proxmox VMs (NixOS)

1. Create a new VM. Most default settings suffice.

   > [!NOTE]
   > The SCSI Controller must be set to some of the VirtIO options. Others do not work!

2. For UEFI: Select OVMF as the BIOS & create an "EFI Disk" for it.
3. Load a NixOS installer ISO.
4. Boot into the VM and disable Secure Boot.
5. Boot into the NixOS installer.
6. Enable the ssh daemon: `sudo systemctl start sshd`
7. Set a temporary password for root via `sudo -i` and then `passwd`.
8. Install NixOS with nix-anywhere via SSH to the target VM.
   ```sh
   nix run github:nix-community/nixos-anywhere -- --flake .#HOSTNAME --target-host root@HOST_IP
   ```
9. Remove the NixOS installer ISO.

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
