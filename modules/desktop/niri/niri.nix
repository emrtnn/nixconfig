{inputs, ...}: {
  flake.modules.nixos.niri = {pkgs, ...}: {
    imports = [inputs.niri.nixosModules.niri];

    programs.niri = {
      enable = true;
      package = pkgs.niri;
    };
  };

  flake.modules.homeManager.niri = {config, ...}: {
    programs.niri.config = null;

    xdg.configFile."niri" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixconfig/modules/desktop/niri/dotfiles";
      recursive = true;
    };
  };
}
