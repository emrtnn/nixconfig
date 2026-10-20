{
  flake.modules.nixos.workstation = {...}: {
    services.tailscale.enable = true;

    networking.firewall = {
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [41641];
    };
  };
}
