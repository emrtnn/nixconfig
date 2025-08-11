{
  description = "Python development environment using uv for venvs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs { inherit system; };
      pythonPkgs = pkgs.python313Packages;
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = [
          pkgs.python313
          pkgs.uv
          pkgs.texliveFull # Text rendering distro
          pythonPkgs.manim
        ];

        shellHook = ''
          # Recommended to ensure venv creation is not affected by build reproducibility settings
          unset SOURCE_DATE_EPOCH

          VENV_DIR=".venv"

          # Use absolute paths from Nix to ensure commands are found, even with direnv
          UV_CMD="${pkgs.uv}/bin/uv"
          PYTHON_CMD="${pkgs.python313}/bin/python3"

          # Check if the venv directory itself doesn't exist
          if [ ! -d "$VENV_DIR" ]; then
            echo "🐍 Creating new uv virtual environment in '$VENV_DIR'..."
            $UV_CMD venv -p $PYTHON_CMD "$VENV_DIR"
            echo "✅ Virtual environment created."
            echo "👉 To install packages, run: uv pip install <package-name>"
            echo "   Or create a requirements.txt and run: uv pip install -r requirements.txt"
          fi

          # Always try to activate the venv if the script exists
          if [ -f "$VENV_DIR/bin/activate" ]; then
            source "$VENV_DIR/bin/activate"
            echo "🐍 Welcome! Your uv virtual environment is active."
          else
            echo "❌ Error: Could not find '$VENV_DIR/bin/activate'. The venv may have failed to create."
          fi
        '';
      };
    });
}
e failed to create."
            fi
          '';
        };
      }
    );
}
