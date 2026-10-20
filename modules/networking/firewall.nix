{
  flake.modules.nixos.workstation = {
    networking = {
      networkmanager.wifi.powersave = false;
      firewall = {
        enable = true;
        allowedTCPPorts = [80 443 4444];
      };
    };
  };
}
