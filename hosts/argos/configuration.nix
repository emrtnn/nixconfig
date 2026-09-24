_: {
  imports = [
    # Required: the file generated inside the actual installed VMware guest.
    ./hardware-configuration.nix
    ../../modules/nixos/profiles/base.nix
    ../../modules/nixos/users/impuremonad.nix
    ../../modules/nixos/desktop/base.nix
    ../../modules/nixos/virtualisation/vmware-guest.nix
    ../../modules/nixos/virtualisation/docker.nix
    ../../modules/nixos/desktop/bspwm.nix
    ../../modules/nixos/profiles/security-lab.nix
  ];

  # Fresh UEFI VMware installation; device mappings come only from hardware.
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "26.11";

  networking = {
    hostName = "argos";
    networkmanager.enable = true;
    firewall.enable = true;
  };

  # Retain the installer-created password database; no declarative credentials.
  users.mutableUsers = true;
}
