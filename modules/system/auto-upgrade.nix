{
  flake.modules.nixos.workstation = {
    system.autoUpgrade = {
      enable = true;
      dates = "weekly";
    };
  };
}
