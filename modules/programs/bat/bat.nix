{pkgs, ...}: {
  programs.bat = {
    enable = true;
    # Home Manager installs the theme and rebuilds bat's cache at activation.
    themes.caelus.src = import ../themes/caelus-tmtheme.nix {inherit pkgs;};
  };

  xdg.configFile."bat/config".source = ../../dotfiles/bat/config;
}
