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
    tree-sitter

    # Web: Biome lint/format + vtsls types; Prettier for Astro
    biome
    vtsls
    astro-language-server
    prettier
    yaml-language-server
    vscode-langservers-extracted

    # Nix (The Modern Stack)
    nixd
    alejandra
    statix

    # C/C++: clangd with its integrated clang-tidy checks
    clang-tools
    cppcheck
    neocmakelsp
    cmake-lint
    cmake-format

    # Rust
    rust-analyzer
    cargo
    rustc
    rustfmt
    clippy

    # Zig
    zig
    zls

    # Solidity
    solc
    vscode-solidity-server # Includes Solhint; no separate linter process needed.
    foundry

    # Lua
    lua-language-server
    stylua

    # Shell
    shellcheck

    # Docker: language services + Dockerfile/ShellCheck best-practice checks
    dockerfile-language-server
    docker-compose-language-service
    hadolint
  ];

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixconfig/dotfiles/nvim";
    recursive = true;
  };
}
