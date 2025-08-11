{
  description = "NextJS Template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs { inherit system; };
      buildInputs = with pkgs; [
        nodejs_24
        nodePackages_latest.pnpm
      ];
    in {
      devShells.default = pkgs.mkShell {
        inherit buildInputs;
        shellHook = ''
          echo "🐳 Welcome to your T3 Next.js dev environment on ${system}"
        '';
      };
    });
}
