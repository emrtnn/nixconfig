{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../programs/pi.nix
    ../programs/oh-my-pi.nix
  ];

  home.packages = with pkgs; [
    herdr
  ];

  xdg.configFile."herdr/config.toml".source = ../../../dotfiles/herdr/config.toml;

  home.file.".pi" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/impuremonad/nixconfig/dotfiles/pi";
    recursive = true;
  };
}
