{...}: {
  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      insertNameservers = ["9.9.9.9" "149.112.112.112"];
    };

    nameservers = ["9.9.9.9" "149.112.112.112"];
  };

  services.resolved = {
    enable = true;
    settings.Resolve = {
      DNSSEC = "true";
      Domains = ["~."];
      DNS = ["9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net"];
      FallbackDNS = ["9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net"];
      DNSOverTLS = "true";
    };
  };
}
