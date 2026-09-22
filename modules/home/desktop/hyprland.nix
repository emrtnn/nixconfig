{config, ...}: {
  xdg.configFile = {
    "hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/impuremonad/nixconfig/dotfiles/hypr";
      recursive = true;
    };

    "uwsm/env".source = "${config.home.sessionVariablesPackage}/etc/profile.d/hm-session-vars.sh";
  };
}
