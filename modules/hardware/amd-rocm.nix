{
  flake.modules.nixos.amd-rocm = {
    lib,
    pkgs,
    ...
  }: {
    services.xserver.videoDrivers = ["amdgpu"];

    hardware.amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
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
  };
}
