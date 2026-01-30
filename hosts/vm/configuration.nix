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

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/9307b364-0b54-4799-8031-ef809b1af2ef";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/758B-FF17";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

  # Shared folders (if configured in VM)
  # fileSystems."/mnt/shared" = {
  #   device = "share";
  #   fsType = "9p";
  #   options = [ "trans=virtio" "version=9p2000.L" ];
  # };
}
