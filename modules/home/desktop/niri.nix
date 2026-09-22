{config, ...}: {
  programs.niri.config = null;

  xdg.configFile."niri" = {
    source = config.lib.file.mkOutOfStoreSymlink "/home/impuremonad/nixconfig/dotfiles/niri";
    recursive = true;
  };
}
