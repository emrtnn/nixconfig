{
  flake.modules.nixos.desktop = {...}: {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

  flake.modules.nixos.workstation = {
    services.pipewire.jack.enable = true;
  };
}
