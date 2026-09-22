{config, ...}: {
  home = {
    username = "impuremonad";
    homeDirectory = "/home/impuremonad";
    stateVersion = "26.05";
  };

  xdg.enable = true;

  systemd.user.sessionVariables = config.home.sessionVariables;
}
