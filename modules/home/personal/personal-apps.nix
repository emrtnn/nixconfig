{pkgs, ...}: {
  imports = [../programs/onlyoffice.nix];

  home.packages = with pkgs; [
    obsidian
    firefox
    telegram-desktop
    mpv
    vesktop
    stremio-linux-shell
  ];

  home.sessionVariables.CHROME_PATH = "${pkgs.google-chrome}/bin/google-chrome";
}
