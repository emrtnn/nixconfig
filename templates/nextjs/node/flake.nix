{
  description = "A minimal Nix Flake for a Next.js + Bun development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    systems.url = "github:nix-systems/x86_64-linux";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
      };
    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          nodejs_20
          nodePackages_latest.pnpm
          biome
        ];
        shellHook = ''
          echo "✅ Node + Next.js environment ready."
          nu
        '';
      };

      formatter = pkgs.nixpkgs-fmt;
    });
}
