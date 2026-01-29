# PLACEHOLDER - Generate this file on your amd64 machine by running:
#   sudo nixos-generate-config --show-hardware-config > hardware-configuration.nix
#
# Copy the output here.

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ ];

  # Boot
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # Filesystems - REPLACE THESE with your actual UUIDs
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-UUID";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/REPLACE-WITH-YOUR-UUID";
    fsType = "vfat";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
