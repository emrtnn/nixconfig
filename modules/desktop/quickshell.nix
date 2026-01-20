{
  pkgs,
  inputs,
  ...
}: {
  programs.quickshell = {
    enable = true;
    package = inputs.quickshell.packages.${pkgs.system}.default.withModules (with pkgs.qt6; [
      qtsvg
      qt5compat
      qtimageformats
    ]);
    systemd.enable = false;
  };
}
