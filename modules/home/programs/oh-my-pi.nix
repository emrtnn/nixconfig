{inputs, ...}: {
  imports = [inputs.oh-my-pi.homeManagerModules.default];

  programs.omp = {
    enable = true;
    settings = {
      startup.quiet = true;
      setupVersion = 2;
      theme.dark = "dark-gruvbox";
      symbolPreset = "unicode";
      defaultThinkingLevel = "high";
      edit.mode = "hashline";
    };
  };
}
