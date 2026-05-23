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
    prettier # Keep prettier ONLY for Astro, Biome is still perfecting Astro support

    # Nix (The Modern Stack)
    nixd
    alejandra

    # C/C++
    clang-tools
    cmake-language-server

    # Rust
    rust-analyzer
    cargo
    rustc
    rustfmt

    # Lua
    lua-language-server
    stylua
  ];

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixconfig/dotfiles/nvim";
    recursive = true;
  };
}
