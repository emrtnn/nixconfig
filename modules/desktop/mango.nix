{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.mangowm.nixosModules.mango
  ];

  programs.mango = {
    enable = true;
  };

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    wlr = {
      enable = true;
    };
    extraPortals = [pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal];
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
