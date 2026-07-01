{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.hunk.homeManagerModules.default];

  programs.hunk = {
    enable = true;
    enableGitIntegration = true;
    settings = {
      theme = "gruvbox-dark-medium";
      mode = "split";
      line_numbers = true;
    };
  };
}
