{pkgs, ...}: {
  programs.bat = {
    enable = true;
    # Home Manager installs the theme and rebuilds bat's cache at activation.
    themes.oxocarbon-dark.src = import ../themes/oxocarbon-tmtheme.nix {inherit pkgs;};
  };

  xdg.configFile."bat/config".source = ../../dotfiles/bat/config;
}
