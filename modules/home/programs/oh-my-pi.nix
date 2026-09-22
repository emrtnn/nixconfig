{inputs, ...}: {
  imports = [inputs.oh-my-pi.homeManagerModules.default];

  programs.omp = {
    enable = true;
    settings.startup.quiet = true;
  };
}
