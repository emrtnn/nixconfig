{ pkgs, ... }:
{
  home.packages = with pkgs; [
    typescript
    nodePackages_latest.nodejs

    vtsls
  ];

  programs.bun = {
    enable = true;
  };
}
