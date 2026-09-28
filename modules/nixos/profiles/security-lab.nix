{pkgs, ...}: {
  programs = {
    ssh.startAgent = false;

    wireshark = {
      enable = true;
      package = pkgs.wireshark;
    };
  };

  users.users.impuremonad.extraGroups = ["wireshark"];
}
