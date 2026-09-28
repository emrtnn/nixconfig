{
  lib,
  pkgs,
  ...
}: {
  programs.zsh.enable = true;

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
    cmake
    e2fsprogs
  ]);
}
