{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.niri.nixosModules.niri
  ];

  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  home-manager.sharedModules = [
    ({config, ...}: {
      programs.niri.config = null;

      xdg.configFile."niri" = {
        source = config.lib.file.mkOutOfStoreSymlink "/home/impuremonad/nixconfig/dotfiles/niri";
        recursive = true;
      };
    })
  ];
}
