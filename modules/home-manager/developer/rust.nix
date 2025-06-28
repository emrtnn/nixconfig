{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (rust-bin.stable.latest.default.override {
      extensions = [ "rust-src" "rustfmt" "clippy" ];
    })
    rust-analyzer
    cargo-watch
    cargo-audit
    cargo-deny
    cargo-expand
  ];
}
