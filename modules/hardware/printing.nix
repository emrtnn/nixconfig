{
  flake.modules.nixos.printing = {pkgs, ...}: {
    services = {
      # Printers
      printing = {
        enable = true;
        drivers = [pkgs.gutenprint];
      };

      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };
    };
  };
}
