{
  flake.modules.nixos.workstation = {pkgs, ...}: {
    boot = {
      # Zen kernel: desktop-tuned scheduler/latency, good fit for a Ryzen 5 3600
      # gaming desktop. The NVIDIA module is built against it automatically.
      kernelPackages = pkgs.linuxPackages_zen;
      loader = {
        systemd-boot.enable = false;
        limine.enable = true;
        efi.canTouchEfiVariables = true;
      };

      initrd = {
        enable = true;
        systemd.enable = true;
        verbose = false;
      };
      consoleLogLevel = 0;
    };
  };
}
