{config, ...}: {
  xdg.enable = true;

  home.sessionPath = ["$HOME/.local/bin"];

  systemd.user.sessionVariables = config.home.sessionVariables;
}
