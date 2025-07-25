{
  description = "A Nix Flake for a modern Python development environment using uv and ruff";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
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
          python313
          uv
          ruff
          pyright
        ];
        shellHook = ''
          echo "✅ Python environment with uv + ruff is ready."

          if [ ! -d ".venv" ]; then
            echo "🐍 No virtual environment found. Creating one with 'uv venv'..."
            uv venv --python ${pkgs.python313}/bin/python
          fi
          
          source .venv/bin/activate

          nu
        '';
      };

      formatter = pkgs.nixpkgs-fmt;
    });
}
