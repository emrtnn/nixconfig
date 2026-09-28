{config, ...}: {
  xdg.enable = true;

  systemd.user.sessionVariables = config.home.sessionVariables;
}
