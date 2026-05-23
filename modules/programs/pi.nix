{pkgs, ...}: {
  home.packages = with pkgs; [
    pi-coding-agent
    nodejs_24
    pnpm
  ];
}
