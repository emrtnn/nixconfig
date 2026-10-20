{
  flake.modules.nixos.desktop = _: {
    virtualisation.docker.enable = true;

    networking.firewall.interfaces.docker0.allowedTCPPorts = [80 443];

    users.users.impuremonad.extraGroups = ["docker"];
  };
}
