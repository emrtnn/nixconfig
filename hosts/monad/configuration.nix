{
  config,
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
    ../../nixos/security/ssh-agent.nix
    ../../nixos/programs/wireshark.nix
    ../../nixos/virtualisation/docker.nix
    ../../nixos/boot/quiet-boot.nix
    ../../nixos/system/zram.nix
    ../../nixos/networking/quad9.nix
    ../../nixos/networking/openvpn.nix
    ../../nixos/networking/tor.nix
    ../../nixos/networking/proxychains.nix
    ../../nixos/networking/syncthing.nix
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
    networkmanager.wifi.powersave = false;
    firewall = {
      enable = true;
      allowedTCPPorts = [80 443 4444];
    };
  };

  programs.silentSDDM.profileIcons.impuremonad = ../../assets/.face;

  boot = {
    # Zen kernel: desktop-tuned scheduler/latency, good fit for a Ryzen 5 3600
    # gaming desktop. The NVIDIA module is built against it automatically.
    kernelPackages = pkgs.linuxPackages_zen;
    loader = {
      systemd-boot.enable = false;
      limine.enable = true;
      efi.canTouchEfiVariables = true;
    };
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
    # Ryzen 5 3600 (Zen 2)
    cpu.amd.updateMicrocode = true;

    enableRedistributableFirmware = true;

    # RTX 2070 Super (Turing): supported by NVIDIA's open kernel modules.
    nvidia = {
      package = config.boot.kernelPackages.nvidiaPackages.stable;
      open = true;
      modesetting.enable = true; # also sets nvidia-drm.modeset=1 / fbdev=1
      # Saves VRAM to /tmp on suspend so the session survives resume.
      powerManagement.enable = true;
      # Fine-grained (RTD3) is only for PRIME laptops.
      powerManagement.finegrained = false;
      nvidiaSettings = true;
    };

    # VA-API -> NVDEC for hardware video decode (browsers, mpv).
    graphics.extraPackages = [pkgs.nvidia-vaapi-driver];
  };

  environment = {
    # Copy /etc/hosts instead of symlinking to the read-only store,
    # so it can be edited at runtime (overwritten on next rebuild).
    etc.hosts.mode = "0644";

    systemPackages = lib.mkAfter (with pkgs; [
      nvtopPackages.nvidia
    ]);

    sessionVariables = {
      LIBVA_DRIVER_NAME = "nvidia";
      NVD_BACKEND = "direct";
    };
  };

  system = {
    stateVersion = "25.11";
    autoUpgrade = {
      enable = true;
      dates = "weekly";
    };
  };
}
