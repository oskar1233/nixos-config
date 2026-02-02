{ config, pkgs, lib, zen-browser, ... }:

let
  fs = lib.fileset;
  sourceFiles = ../nvim;
in

fs.trace sourceFiles

{
  # Nix settings
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Bootloader - can be overridden per host
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  boot.loader.efi.canTouchEfiVariables = lib.mkDefault true;

  # Networking
  networking.networkmanager.enable = true;

  # Locale
  time.timeZone = lib.mkDefault "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  # User
  users.users.oskar1233 = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    shell = pkgs.bash;
  };

  # Niri / Wayland
  programs.niri = {
    enable = true;
  };

  # Greetd display manager
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri-session";
        user = "greeter";
      };
    };
  };

  # XDG portal for Wayland
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };

  # PipeWire for audio
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # System packages
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    unzip
    ripgrep
    fd
    htop
    tree
  ];

  # Home-manager
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.oskar1233 = import ../home;
    extraSpecialArgs = { inherit zen-browser; };
  };

  # Security
  security.rtkit.enable = true;  # For PipeWire
  security.polkit.enable = true; # For Wayland

  # System version - don't change after initial install
  system.stateVersion = "25.11";
}
