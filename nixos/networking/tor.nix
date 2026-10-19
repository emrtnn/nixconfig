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
      # SafeSocks would reject IP-only SOCKS requests. It is a global option,
      # and Telegram always connects to its DCs by raw IP, so it must be off.
      # Apps that resolve hostnames should still use socks5h / torsocks.
      SafeSocks = false;
      # Warn (don't reject) when an app hands Tor a bare IP.
      WarnUnsafeSocks = false;
    };
  };
}
