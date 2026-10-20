{
  flake.modules.nixos.nvidia = {
    config,
    lib,
    pkgs,
    ...
  }: {
    services.xserver.videoDrivers = ["nvidia"];

    hardware = {
      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.latest;
        open = true;
        modesetting.enable = true; # also sets nvidia-drm.modeset=1 / fbdev=1
        powerManagement.enable = true;
        powerManagement.finegrained = false;
        nvidiaSettings = true;
      };

      graphics.extraPackages = [pkgs.nvidia-vaapi-driver];
    };

    environment = {
      systemPackages = lib.mkAfter (with pkgs; [
        nvtopPackages.nvidia
      ]);

      sessionVariables = {
        LIBVA_DRIVER_NAME = "nvidia";
        NVD_BACKEND = "direct";
      };
    };
  };
}
