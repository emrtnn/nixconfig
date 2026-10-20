{
  flake.modules.nixos.desktop = {...}: {
    programs.dconf.enable = true;

    hardware.graphics.enable = true;

    services.gvfs.enable = true;
  };
}
