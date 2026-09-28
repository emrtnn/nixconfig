{pkgs, ...}: {
  home.packages = [pkgs.bat];

  xdg.configFile."bat/config".source = ../../dotfiles/bat/config;
}
