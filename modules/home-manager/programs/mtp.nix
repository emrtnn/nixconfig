{ pkgs, ... }:
{
  home.packages = with pkgs; [
    libmtp
    jmtpfs
    usbutils
  ];
}
