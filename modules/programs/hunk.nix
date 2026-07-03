{inputs, ...}: {
  imports = [inputs.hunk.homeManagerModules.default];

  programs.hunk = {
    enable = true;
    enableGitIntegration = true;
    settings = {
      theme = "gruvbox-dark-hard";
      mode = "split";
      line_numbers = true;
    };
  };
}
