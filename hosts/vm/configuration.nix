{ config, pkgs, lib, ... }:

{
  networking.hostName = "nixos-vm";

  # VM-specific settings
  # Adjust based on your VM software (UTM, Parallels, etc.)
  
  # For UTM/QEMU on Apple Silicon
  boot.initrd.availableKernelModules = [ "xhci_pci" "virtio_pci" "virtio_scsi" "usbhid" ];
  boot.kernelModules = [ ];

  # SPICE guest tools for clipboard sharing, display resize (if using SPICE)
  services.spice-vdagentd.enable = true;

  # Shared folders (if configured in VM)
  # fileSystems."/mnt/shared" = {
  #   device = "share";
  #   fsType = "9p";
  #   options = [ "trans=virtio" "version=9p2000.L" ];
  # };
}
