{pkgs, ...}: {
  home.packages = with pkgs; [
    lazygit
    ripgrep
    fd
    dnsutils
    duckdb
    btop
    gh
    unzip
    file
    jq
  ];
}
