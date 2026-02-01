{
  pkgs,
  inputs,
  ...
}: let
  pkgs-stable = import inputs.nixpkgs-stable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  programs.vesktop = {
    enable = true;
    package = pkgs-stable.vesktop;
  };
}
