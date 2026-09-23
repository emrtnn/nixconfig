{
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/profiles/personal.nix
    ../../modules/nixos/virtualisation/docker.nix
  ];

  networking.hostName = "arpano";

  boot.kernelPackages = pkgs.linuxPackages_zen;

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
  };

  hardware = {
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

  system.stateVersion = "25.11";

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/impuremonad/.config/sops/age/keys.txt";
  };
}
