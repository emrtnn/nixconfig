{pkgs, ...}: {
  imports = [
    # Required: the file generated inside the actual installed VMware guest.
    ./hardware-configuration.nix
    ../../base/base.nix
    ../../nixos/desktop/session-support.nix
    ../../nixos/desktop/fonts.nix
    ../../nixos/audio/pipewire.nix
    ../../nixos/security/gnome-keyring.nix
    ../../nixos/programs/wireshark.nix
    ../../nixos/networking/openvpn.nix
    ../../nixos/virtualisation/docker.nix
    ../../nixos/virtualisation/vmware-guest.nix
    ../../nixos/desktop/bspwm.nix
  ];

  home-manager.users.impuremonad = import ./home.nix;

  users.users.impuremonad = {
    isNormalUser = true;
    description = "impuremonad";
    shell = pkgs.zsh;
    extraGroups = ["networkmanager" "wheel" "video" "render" "wireshark" "docker"];
  };

  programs.ssh.startAgent = false;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
    pinentryPackage = pkgs.pinentry-qt;
    settings = {
      default-cache-ttl = 7200;
      max-cache-ttl = 14400;
    };
  };

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = false;
    };
    defaultSession = "none+bspwm";
  };

  # Fresh UEFI VMware installation; device mappings come only from hardware.
  boot.loader = {
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 5;
    efi.canTouchEfiVariables = true;
  };

  system.stateVersion = "26.11";

  networking = {
    hostName = "argos";
    networkmanager.enable = true;
    firewall = {
      enable = true;
    };
    extraHosts = ''
      10.129.10.222 unika.htb
    '';
  };

  # Retain the installer-created password database; no declarative credentials.
  users.mutableUsers = true;
}
