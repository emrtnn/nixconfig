{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # Recommended for xdg-desktop-portal-hyprland and screen sharing.
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  home-manager.sharedModules = [
    ({config, ...}: {
      xdg.configFile = {
        "hypr" = {
          source = config.lib.file.mkOutOfStoreSymlink "/home/impuremonad/nixconfig/dotfiles/hypr";
          recursive = true;
        };

        # UWSM reads this for environment setup before the compositor starts.
        "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
      };
    })
  ];
}
