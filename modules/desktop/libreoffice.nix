{pkgs, ...}: {
  home.packages = with pkgs; [
    libreoffice-qt-fresh
    hunspell
    hunspellDicts.es_ES
    hunspellDicts.en_US
  ];
}
