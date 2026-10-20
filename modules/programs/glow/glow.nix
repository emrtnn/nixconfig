{
  flake.modules.homeManager.base = {pkgs, ...}: {
    home.packages = [pkgs.glow];

    xdg.configFile."glow/glow.yml".source = ./dotfiles/glow.yml;
  };
}
