{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-conf.nix
    ../../base/base.nix
    ../../nixos/desktop/session-support.nix
    ../../nixos/desktop/fonts.nix
    ../../nixos/audio/pipewire.nix
    ../../nixos/security/gnome-keyring.nix
    ../../nixos/programs/wireshark.nix
    ../../nixos/virtualisation/docker.nix
    ../../nixos/boot/quiet-boot.nix
    ../../nixos/system/zram.nix
    ../../nixos/networking/quad9.nix
    ../../nixos/networking/openvpn.nix
    ../../nixos/networking/tor.nix
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
    hostName = "arpano";
    networkmanager.wifi.powersave = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443];
    };
    extraHosts = ''
      10.129.153.25 management.htb
      10.129.153.25 sso.management.htb
    '';
  };

  programs = {
    ssh.startAgent = false;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-qt;
      settings = {
        default-cache-ttl = 7200;
        max-cache-ttl = 14400;
      };
    };
    silentSDDM.profileIcons.impuremonad = ../../assets/.face;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      systemd-boot.enable = false;
      limine.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  services = {
    # Printers
    printing = {
      enable = true;
      drivers = [pkgs.gutenprint];
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    xserver.videoDrivers = ["amdgpu"];
    pipewire.jack.enable = true;
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };

    enableRedistributableFirmware = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  powerManagement = {
    enable = true;
    resumeCommands = ''
      ${pkgs.kmod}/bin/modprobe -r r8125
      ${pkgs.kmod}/bin/modprobe r8125
      sleep 2
      systemctl restart NetworkManager.service
    '';
  };

  environment = {
    systemPackages = lib.mkAfter (with pkgs; [
      rocmPackages.rocm-core
      rocmPackages.clr
      rocmPackages.clr.icd
      radeontop
      nvtopPackages.amd
    ]);

    variables = {
      HIP_PATH = "${pkgs.rocmPackages.clr}";
      ROCM_PATH = "${pkgs.rocmPackages.clr}";
    };

    sessionVariables.HSA_OVERRIDE_GFX_VERSION = "11.0.0";
  };

  nixpkgs.config.rocmSupport = true;

  system = {
    stateVersion = "25.11";
    autoUpgrade = {
      enable = true;
      dates = "weekly";
    };
  };
}
