{lib, pkgs, ...}: {
  services.xserver = {
    enable = true;
    windowManager.bspwm.enable = true;
    xkb = {
      layout = "us";
      variant = "altgr-intl";
    };
  };

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = false;
    };
    defaultSession = "none+bspwm";
  };

  security.polkit.enable = true;
  programs.i3lock.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = lib.mkForce pkgs.pinentry-qt;
  };

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
