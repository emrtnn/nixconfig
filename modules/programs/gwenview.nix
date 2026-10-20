{
  lib,
  pkgs,
  ...
}: let
  desktop = "org.kde.gwenview.desktop";
  mimeTypes = [
    "image/png"
    "image/jpeg"
    "image/gif"
    "image/webp"
    "image/svg+xml"
    "image/bmp"
    "image/tiff"
    "image/avif"
    "image/heic"
    "image/heif"
    "image/jxl"
    "image/x-icon"
  ];
in {
  home.packages = with pkgs.kdePackages; [
    gwenview
    # Qt plugins for AVIF, HEIF, JPEG XL, EXR, RAW, PSD, etc.
    kimageformats
  ];

  xdg.mimeApps.defaultApplications = lib.genAttrs mimeTypes (_: desktop);
}
