{
  description = "A minimal Nix Flake for a Rust development environment";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
    ...
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [rust-overlay.overlays.default];
      };

      rustToolchain = pkgs.rust-bin.stable.latest.default.override {
        extensions = ["rust-src" "clippy" "rustfmt"];
      };

    in {
      devShells.default = pkgs.mkShell {
        packages = with pkgs; [
          rustToolchain

          # Common cargo tools for development
          cargo-watch  # Automatically re-run commands on file changes
          cargo-audit  # Check for security vulnerabilities
          cargo-deny   # Check for license and crate policy violations
          cargo-expand # Show macro expansion

          # Common system libraries required by many Rust crates
          openssl
          pkg-config
        ];

        # Environment variables needed for some crates to find libraries.
        # RUST_SRC_PATH is for rust-analyzer to find the standard library source.
        RUST_SRC_PATH = "${rustToolchain}/lib/rustlib/src/rust/library";
        LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath [pkgs.openssl];

        shellHook = ''
          echo "✅ Rust development environment ready."
          nu
        '';
      };

      formatter = pkgs.nixpkgs-fmt;
    });
}
