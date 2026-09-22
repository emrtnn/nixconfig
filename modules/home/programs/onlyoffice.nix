{pkgs, ...}: {
  home.packages = with pkgs; [
    onlyoffice-desktopeditors
  ];

  xdg.mimeApps.defaultApplications."application/pdf" = "onlyoffice-desktopeditors.desktop";
}
