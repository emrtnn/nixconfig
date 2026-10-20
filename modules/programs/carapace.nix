{
  flake.modules.homeManager.base = _: {
    programs.carapace = {
      enable = true;
      enableNushellIntegration = true;
      enableZshIntegration = true;
    };
  };
}
