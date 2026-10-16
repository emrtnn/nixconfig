{
  pkgs,
  lib,
  config,
  ...
}: let
  # Pinned plugins, linked to ~/.config/vis/plugins/<name>.
  plugins = {
    vis-autoclose = pkgs.fetchgit {
      url = "https://codeberg.org/luxanna/vis-autoclose";
      rev = "b7657b363baf0b87a192d21deca0891a0c0378fe";
      hash = "sha256-XM/GcWzdkrwW64X4YSw1+/5g77Jakbd7bUALdmaRhwI=";
    };
    vis-lspc = pkgs.fetchFromGitLab {
      owner = "muhq";
      repo = "vis-lspc";
      rev = "9d0f7a0b82b1983b44636259733d6d2c39497315";
      hash = "sha256-lA9ZzYeq7td5x5mBE8hCc7xzbRNMl8slm0H4o1P9dlc=";
    };
  };
in {
  home.packages = [pkgs.vis];

  # Link entries individually: plugins can't live inside an out-of-store symlink.
  xdg.configFile =
    lib.genAttrs ["vis/visrc.lua" "vis/themes"] (path: {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixconfig/dotfiles/${path}";
    })
    // lib.mapAttrs' (name: src: lib.nameValuePair "vis/plugins/${name}" {source = src;}) plugins;
}
