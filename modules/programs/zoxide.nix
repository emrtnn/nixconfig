{
  flake.modules.homeManager.base = _: {
    programs.zoxide = {
      enable = true;
      enableNushellIntegration = false;
      enableZshIntegration = true;
      options = ["--cmd cd"];
    };
  };
}
