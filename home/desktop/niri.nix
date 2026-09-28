{config, ...}: {
  programs.niri.config = null;

  xdg.configFile."niri" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixconfig/dotfiles/niri";
    recursive = true;
  };
}
