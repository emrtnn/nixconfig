{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../programs/foot.nix
    ./noctalia.nix
    ./swappy.nix
  ];

  home.packages = with pkgs; [
    grim
    slurp
    hyprpicker
    brightnessctl
    qt5.qtwayland
    qt6.qtwayland
    wl-clipboard
    wtype
  ];

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  xdg.configFile = {
    "mango" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/impuremonad/nixconfig/dotfiles/mango";
      recursive = true;
    };

    "xdg-desktop-portal/mango-portals.conf".source = ../../../dotfiles/xdg-desktop-portal/portals.conf;
  };
}
