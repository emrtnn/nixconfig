_: {
  virtualisation.docker.enable = true;

  networking.firewall.interfaces.docker0.allowedTCPPorts = [80 443];
}
