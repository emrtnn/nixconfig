{pkgs, ...}: {
  imports = [
    ./hardware-conf.nix
    ../../base/base.nix
    ../../nixos/desktop/session-support.nix
    ../../nixos/desktop/fonts.nix
    ../../nixos/audio/pipewire.nix
    ../../nixos/security/gnome-keyring.nix
    ../../nixos/security/ssh-agent.nix
    ../../nixos/security/gnupg.nix
    ../../nixos/programs/wireshark.nix
    ../../nixos/virtualisation/docker.nix
    ../../nixos/boot/quiet-boot.nix
    ../../nixos/system/zram.nix
    ../../nixos/networking/quad9.nix
    ../../nixos/networking/openvpn.nix
    ../../nixos/networking/tor.nix
    ../../nixos/networking/proxychains.nix
    ../../nixos/services/openssh.nix
    ../../nixos/services/tailscale.nix
    ../../nixos/programs/localsend.nix
    ../../nixos/desktop/silent-sddm.nix
    ../../nixos/programs/gaming.nix
    ../../nixos/desktop/mango.nix
  ];

  home-manager.users.impuremonad = import ./home.nix;

  users.users.impuremonad = {
    isNormalUser = true;
    description = "impuremonad";
    shell = pkgs.zsh;
    extraGroups = ["networkmanager" "wheel" "video" "render" "wireshark" "docker" "gamemode"];
  };

  networking = {
    hostName = "monad";
    firewall.enable = true;
    networkmanager.wifi.powersave = false;
  };

  programs.silentSDDM.profileIcons.impuremonad = ../../assets/.face;

  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      limine = {
        enable = true;
        # This host has a 196M EFI partition, so keeping multiple initrds
        # around under /boot/limine quickly exhausts the available space.
        maxGenerations = 2;
        extraEntries = ''
          /Windows 11
            protocol: efi_chainload
            image_path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
        '';
      };
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["nvidia-drm.modeset=1"];
  };

  services = {
    xserver.videoDrivers = ["nvidia"];
    pipewire.jack.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    nvidia = {
      modesetting.enable = true;
      open = true;
      powerManagement = {
        enable = false;
        finegrained = false;
      };
      nvidiaSettings = true;
    };
  };

  environment.sessionVariables = {
    WLR_DRM_DEVICES = "/dev/dri/card1";
    WLR_DRM_NO_ATOMIC = "1";
  };

  system = {
    stateVersion = "25.11";
    autoUpgrade = {
      enable = true;
      dates = "weekly";
    };
  };
}
