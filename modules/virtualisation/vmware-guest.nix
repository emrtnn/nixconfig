{
  flake.modules.nixos.vmware-guest = {
    lib,
    pkgs,
    ...
  }: {
    virtualisation.vmware.guest = {
      enable = true;
      headless = false;
    };

    services.xserver.videoDrivers =
      lib.optionals pkgs.stdenv.hostPlatform.isx86 ["vmware"]
      ++ ["modesetting"];
  };
}
