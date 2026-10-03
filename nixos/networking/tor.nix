{pkgs, ...}: {
  # Tor Browser keeps its bundled Tor and browser privacy defaults. The system
  # daemon below is for explicitly proxied applications, not the whole host.
  environment.systemPackages = with pkgs; [tor-browser torsocks];

  services.tor = {
    enable = true;
    relay.enable = false;
    openFirewall = false;
    client = {
      enable = true;
      socksListenAddress = {
        addr = "127.0.0.1";
        port = 9050;
        IsolateDestAddr = true;
        IsolateSOCKSAuth = true;
      };
    };
    settings = {
      ClientOnly = true;
      # Reject SOCKS requests that could have resolved DNS outside Tor. This
      # also rejects some IP-only requests; pass hostnames through the proxy.
      SafeSocks = true;
    };
  };

  programs.proxychains = {
    enable = true;
    package = pkgs.proxychains-ng;
    chain.type = "strict";
    proxyDNS = true;
    # Override the module's automatic torproxy entry rather than adding a
    # second proxy hop. SOCKS5 carries hostnames to Tor for remote resolution.
    proxies.torproxy = {
      enable = true;
      type = "socks5";
      host = "127.0.0.1";
      port = 9050;
    };
  };
}
