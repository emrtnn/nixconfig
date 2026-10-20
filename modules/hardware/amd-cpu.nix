{
  flake.modules.nixos.workstation = {
    hardware = {
      cpu.amd.updateMicrocode = true;

      enableRedistributableFirmware = true;
    };
  };
}
