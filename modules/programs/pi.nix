{pkgs, ...}: {
  home.packages = with pkgs; [
    pi-coding-agent
    nodejs_25
    pnpm
  ];
}
