{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";

    settings = {
      mrg = {linemode = "size";};
    };

    plugins = {
      inherit (pkgs.yaziPlugins) full-border;
    };
  };
}
