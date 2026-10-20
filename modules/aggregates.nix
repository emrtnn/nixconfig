{
  config,
  lib,
  ...
}: let
  names = [
    "base"
    "desktop"
    "workstation"
    "mango"
    "bspwm"
    "niri"
    "hyprland"
    "gaming"
    "helix"
    "herdr"
    "nushell"
    "fastfetch"
    "nvidia"
    "amd-rocm"
    "printing"
    "bluetooth"
    "vmware-guest"
    "monad"
    "arpano"
    "argos"
  ];
  hm = config.flake.modules.homeManager;
in {
  flake.modules.homeManager = lib.genAttrs names (_: {});
  flake.modules.nixos = lib.genAttrs names (name: {
    home-manager.sharedModules = [hm.${name}];
  });
}
