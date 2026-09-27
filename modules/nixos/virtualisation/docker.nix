_: {
  virtualisation.docker.enable = true;

  users.users.impuremonad.extraGroups = ["docker"];

  networking.firewall.interfaces.docker0.allowedTCPPorts = [80 443];
}
