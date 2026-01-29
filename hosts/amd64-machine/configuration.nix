{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix  # Generate with nixos-generate-config
  ];

  networking.hostName = "nixos-amd64";

  # AMD/Intel specific kernel modules
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.kernelModules = [ "kvm-amd" ];  # or kvm-intel

  # GPU drivers - uncomment as needed
  # services.xserver.videoDrivers = [ "amdgpu" ];  # AMD
  # services.xserver.videoDrivers = [ "nvidia" ];  # NVIDIA
  # hardware.nvidia.modesetting.enable = true;     # For NVIDIA on Wayland

  # Firmware updates
  services.fwupd.enable = true;

  # Hardware-specific packages
  environment.systemPackages = with pkgs; [
    pciutils
    usbutils
    lm_sensors
  ];
}
