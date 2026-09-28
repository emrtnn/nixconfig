{inputs, ...}: {
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
}
