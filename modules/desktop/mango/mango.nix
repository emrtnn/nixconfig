{inputs, ...}: {
  flake.modules.nixos.mango = {
    imports = [inputs.mangowm.nixosModules.mango];

    programs = {
      mango.enable = true;

      # Installs gpu-screen-recorder system-wide and provides the privileged
      # gsr-kms-server wrapper needed for direct monitor capture.
      gpu-screen-recorder.enable = true;
    };

    # The upstream Mango module installs the GTK/wlr portals and Mango's
    # systemd session target. Route xdg-open through those portals. Mango has no
    # compatible xdg-desktop-portal-wlr output chooser, so select the sole output
    # directly instead of failing after trying unavailable dmenu launchers.
    xdg.portal = {
      xdgOpenUsePortal = true;
      wlr.settings.screencast.chooser_type = "none";
    };

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };

  flake.modules.homeManager.mango = {
    config,
    pkgs,
    ...
  }: {
    home.packages = with pkgs; [
      grim
      slurp
      hyprpicker
      brightnessctl
      qt5.qtwayland
      qt6.qtwayland
      wl-clipboard
      wtype
    ];

    services.cliphist = {
      enable = true;
      allowImages = true;
    };

    xdg.configFile = {
      "mango" = {
        source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixconfig/modules/desktop/mango/dotfiles/mango";
        recursive = true;
      };

      "xdg-desktop-portal/mango-portals.conf".source = ./dotfiles/xdg-desktop-portal/portals.conf;
    };
  };
}
