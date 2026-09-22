{pkgs, ...}: {
  home.packages = with pkgs; [
    nautilus
    imv
    evince
    ffmpeg
    playerctl
  ];

  xdg.mimeApps.defaultApplications = {
    "image/png" = "imv.desktop";
    "image/jpeg" = "imv.desktop";
    "image/gif" = "imv.desktop";
    "image/webp" = "imv.desktop";
    "image/svg+xml" = "imv.desktop";
    "image/bmp" = "imv.desktop";
    "image/avif" = "imv.desktop";
  };
}
