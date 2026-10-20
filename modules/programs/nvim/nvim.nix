{
  flake.modules.homeManager.base = {
    pkgs,
    lib,
    config,
    ...
  }: let
    toolchain = import ./_toolchain.nix pkgs;
  in {
    home.packages =
      [
        pkgs.neovim
        pkgs.tree-sitter
      ]
      ++ lib.concatLists (lib.attrValues toolchain);

    xdg.configFile."nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixconfig/modules/programs/nvim/dotfiles";
      recursive = true;
    };
  };
}
