{
  flake.modules.nixos.gaming = {pkgs, ...}: {
    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true;
        protontricks.enable = true;
        extest.enable = true;
        extraCompatPackages = with pkgs; [
          proton-ge-bin
        ];
      };

      gamescope = {
        enable = true;
        capSysNice = false;
      };

      gamemode = {
        enable = true;
        settings = {
          general = {
            renice = 10;
            softrealtime = "auto";
            inhibit_screensaver = 1;
          };
          custom = {
            start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
            end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
          };
        };
      };
    };

    users.users.impuremonad.extraGroups = ["gamemode"];

    boot.kernelModules = ["ntsync"];

    services.udev.extraRules = ''
      KERNEL=="ntsync", MODE="0660", TAG+="uaccess"
    '';

    boot.kernel.sysctl."kernel.split_lock_mitigate" = 0;

    environment = {
      sessionVariables = {
        # NVIDIA's default shader cache is ~1 GB and gets evicted -> recompiles
        # and stutter. DXVK/VKD3D pipelines live here too.
        __GL_SHADER_DISK_CACHE_SIZE = "12000000000";
        __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
      };

      systemPackages = with pkgs; [
        (heroic.override {
          extraPkgs = pkgs: [
            pkgs.gamemode
            pkgs.gamescope
          ];
        })
        umu-launcher

        vulkan-tools
        mesa-demos
      ];
    };

    hardware.graphics.enable32Bit = true;
    services.pipewire.alsa.support32Bit = true;
  };
}
