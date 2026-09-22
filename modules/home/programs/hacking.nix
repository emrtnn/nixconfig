{pkgs, ...}: {
  home.packages = with pkgs; [
    nmap
    burpsuite
    netcat-openbsd
    ffuf
  ];
}
