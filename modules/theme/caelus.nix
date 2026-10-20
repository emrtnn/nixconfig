{lib, ...}: {
  options.theme = lib.mkOption {
    type = lib.types.lazyAttrsOf lib.types.raw;
    default = {};
    description = "Shared theme data: the Caelus palette and generators.";
  };
  config.theme = {
    caelus = import ./_palette.nix;
    caelusTmTheme = pkgs: import ./_tmtheme.nix {inherit pkgs;};
  };
}
