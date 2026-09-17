{
  inputs,
  ...
}: {
  imports = [inputs.mangowm.nixosModules.mango];

  programs.mango.enable = true;

  # The upstream Mango module installs the GTK/wlr portals and Mango's
  # systemd session target. Route xdg-open through those portals.
  xdg.portal.xdgOpenUsePortal = true;

  home-manager.sharedModules = [
    ({config, ...}: {
      xdg.configFile = {
        "mango" = {
          source = config.lib.file.mkOutOfStoreSymlink "/home/impuremonad/nixconfig/dotfiles/mango";
          recursive = true;
        };

        "xdg-desktop-portal/mango-portals.conf".source = ../../dotfiles/xdg-desktop-portal/portals.conf;
      };
    })
  ];
}
