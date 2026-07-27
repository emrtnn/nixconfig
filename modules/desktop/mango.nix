{
  pkgs,
  ...
}: {
  programs.mango = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr = {
      enable = true;
    };
    extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal pkgs.xdg-desktop-portal-wlr];
  };

  home-manager.sharedModules = [
    ({config, ...}: {
      xdg.configFile = {
        "mango" = {
          source = config.lib.file.mkOutOfStoreSymlink "/home/impuremonad/nixconfig/dotfiles/mango";
          recursive = true;
        };

        "xdg-desktop-portal" = {
          source = ../../dotfiles/xdg-desktop-portal;
          recursive = true;
        };
      };
    })
  ];
}
