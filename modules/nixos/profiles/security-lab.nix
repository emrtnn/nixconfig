{pkgs, ...}: {
  programs = {
    ssh.startAgent = false;

    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };

    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
      enableSSHSupport = true;

      settings = {
        default-cache-ttl = 7200;
        max-cache-ttl = 14400;
      };
    };
  };

  users.users.impuremonad.extraGroups = ["wireshark"];
}
