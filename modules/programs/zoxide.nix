_: {
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = false;
    enableZshIntegration = true;
    options = ["--cmd cd"];
  };
}
