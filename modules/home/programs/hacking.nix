{pkgs, ...}: {
  home.packages = with pkgs; [
    nmap
    burpsuite
    netcat-openbsd
    ffuf
    inetutils
    arp-scan
    bc
    tcpdump
    thc-hydra
    samba
    smbmap
    cifs-utils
    netexec
    wpscan
  ];
}
