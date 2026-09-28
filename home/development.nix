{pkgs, ...}: {
  home.packages = with pkgs; [
    devenv
    uv
    python3
    ninja
  ];
}
