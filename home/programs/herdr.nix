{pkgs, ...}: {
  home.packages = with pkgs; [
    herdr
  ];

  xdg.configFile."herdr/config.toml".source = ../../dotfiles/herdr/config.toml;
}
