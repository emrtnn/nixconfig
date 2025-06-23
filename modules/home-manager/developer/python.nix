{ pkgs, ... }:
{
  home.packages = with pkgs; [
    python313

    ruff
  ];

  programs.uv = {
    enable = true;
  };
}
