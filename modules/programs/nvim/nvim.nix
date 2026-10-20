{
  pkgs,
  lib,
  config,
  ...
}: let
  toolchain = import ../toolchains/editors.nix pkgs;
in {
  home.packages =
    [
      pkgs.neovim
      pkgs.tree-sitter
    ]
    ++ lib.concatLists (lib.attrValues toolchain);

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixconfig/dotfiles/nvim";
    recursive = true;
  };
}
