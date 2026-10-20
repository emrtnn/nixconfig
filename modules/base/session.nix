{
  flake.modules.homeManager.base = {
    config,
    lib,
    ...
  }: {
    xdg.enable = true;

    # After the features' PATH entries (e.g. npm/pnpm globals), as before the dendritic
    # migration: module order no longer decides it.
    home.sessionPath = lib.mkAfter ["$HOME/.local/bin"];

    systemd.user.sessionVariables = config.home.sessionVariables;
  };
}
