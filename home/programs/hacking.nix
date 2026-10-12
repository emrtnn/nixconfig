{pkgs, ...}: {
  # Java/Swing (Burp Suite) on non-reparenting compositors such as mango:
  # without this, AWT mis-handles dialogs, which can leave invisible modal
  # windows that freeze the main window.
  home.sessionVariables._JAVA_AWT_WM_NONREPARENTING = "1";

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
    wpscan
    exploitdb
    whatweb
    wordlists
    metasploit
    js-beautify
    sqlmap
    pspy
    cewl
    hashcat
    john
    evil-winrm
    openssl
    python3Packages.impacket
    exiftool
    padbuster
    metasploit
  ];
}
