{
  lib,
  pkgs,
  ...
}: {
  programs.zsh.enable = true;

  programs.nix-ld.enable = true;

  services.locate = {
    enable = true;
    package = pkgs.plocate;
  };

  environment.systemPackages = lib.mkBefore (with pkgs; [
    bash
    zsh
    vim
    wget
    git
    gcc
    gnumake
    cmake
    e2fsprogs
  ]);
}
