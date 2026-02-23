{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/desktop/hyprlock.nix
    ../../modules/desktop/hypridle.nix
  ];

  home.packages = with pkgs; [
    hyprpaper
    hyprpicker
  ];

  xdg.configFile."hypr" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/impuremonad/nixconfig/dotfiles/hypr";
    recursive = true;
  };
}
