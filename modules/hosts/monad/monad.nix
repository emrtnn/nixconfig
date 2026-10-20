{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations.monad = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [base desktop workstation mango gaming nvidia monad];
  };

  flake.modules.nixos.monad = {
    imports = [./_hardware.nix];

    networking.hostName = "monad";

    system.stateVersion = "25.11";
  };

  flake.modules.homeManager.monad = {pkgs, ...}: {
    home = {
      stateVersion = "26.05";
      packages = with pkgs; [
        iptvnator
      ];
    };
  };
}
