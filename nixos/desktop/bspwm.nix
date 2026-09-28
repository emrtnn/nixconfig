{pkgs, ...}: {
  services.xserver = {
    enable = true;
    windowManager.bspwm.enable = true;
    xkb = {
      layout = "us";
      variant = "altgr-intl";
    };
  };

  security.polkit.enable = true;
  programs.i3lock.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
    config.common = {
      default = ["gtk"];
      "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
    };
    xdgOpenUsePortal = true;
  };
}
