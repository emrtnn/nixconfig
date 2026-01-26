{pkgs, ...}: {
  programs.yazi = {
    enable = true;

    settings = {
      mrg = {linemode = "size";};
    };

    plugins = {
      inherit (pkgs.yaziPlugins) full-border;
    };
  };
}
