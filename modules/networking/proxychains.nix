{pkgs, ...}: {
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
