{
  description = "A development environment for a Rust project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
		rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay } :
  let
    system = "x86_64-linux";
		pkgs = import nixpkgs {
		  inherit system;
			overlays = [
				rust-overlay.overlays.default
			];
		};
	in
  {
    devShells.${system}.default = pkgs.mkShell {
      buildInputs = with pkgs; [
        (rust-bin.stable.latest.default.override {
          extensions = ["rust-src" "rustfmt" "clippy"];
        })
        cargo-watch
        cargo-audit
        cargo-deny
        cargo-expand
        openssl
        pkg-config
      ];

      LD_LIBRARY_PATH = with pkgs; lib.makeLibraryPath [ openssl ];

      shellHook = "nu";
    };
  };
}
