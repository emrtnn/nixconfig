{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    neovim
    # Python (The Astral Stack)
    ruff
    basedpyright

    # Modern Web (Replaces Prettier/ESlint and tsserver)
    biome
    vtsls
    astro-language-server
    prettier

    # Nix (The Modern Stack)
    nixd
    alejandra
    statix

    # C/C++
    clang-tools
    neocmakelsp
    cmake-lint
    cmake-format

    # Rust
    rust-analyzer
    cargo
    rustc
    rustfmt

    # Zig
    zig
    zls

    # Lua
    lua-language-server
    stylua

    # Docker hadolint
    hadolint
  ];

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixconfig/dotfiles/nvim";
    recursive = true;
  };
}
