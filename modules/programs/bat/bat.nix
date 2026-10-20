{config, ...}: let
  tmTheme = config.theme.caelusTmTheme;
in {
  flake.modules.homeManager.base = {pkgs, ...}: {
    programs.bat = {
      enable = true;
      # Home Manager installs the theme and rebuilds bat's cache at activation.
      themes.caelus.src = tmTheme pkgs;
    };

    xdg.configFile."bat/config".source = ./dotfiles/config;
  };
}
