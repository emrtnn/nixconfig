{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/profiles/personal.nix
    ../../modules/nixos/virtualisation/docker.nix
  ];

  networking.hostName = "monad";

  boot = {
    loader.limine = {
      # This host has a 196M EFI partition, so keeping multiple initrds
      # around under /boot/limine quickly exhausts the available space.
      maxGenerations = 2;
      extraEntries = ''
        /Windows 11
          protocol: efi_chainload
          image_path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };

    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = ["nvidia-drm.modeset=1"];
  };

  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
    powerManagement = {
      enable = false;
      finegrained = false;
    };
    nvidiaSettings = true;
  };

  environment.sessionVariables = {
    WLR_DRM_DEVICES = "/dev/dri/card1";
    WLR_DRM_NO_ATOMIC = "1";
  };

  system.stateVersion = "25.11";

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/impuremonad/.config/sops/age/keys.txt";
  };
}
