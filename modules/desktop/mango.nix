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
    extraPortals = [pkgs.xdg-desktop-portal-gtk];
  };

  home-manager.sharedModules = [
    ({config, ...}: {
      xdg.configFile = {
        "mango" = {
          source = config.lib.file.mkOutOfStoreSymlink "/home/impuremonad/nixconfig/dotfiles/mango";
          recursive = true;
        };
      };
    })
  ];
}
