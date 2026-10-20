{
  flake.modules.nixos.workstation = {...}: {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 100;
    };
  };
}
