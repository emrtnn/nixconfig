{pkgs, ...}: {
  home.packages = [pkgs.tuicr];

  xdg.configFile."tuicr/config.toml".source = ../../dotfiles/tuicr/config.toml;
}
