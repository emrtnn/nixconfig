# Language servers, formatters and compilers for the editor.
# Data only: home/programs/nvim.nix installs every group.
pkgs:
with pkgs; {
  # Python (The Astral Stack)
  python = [
    ruff
    basedpyright
  ];

  # Web: Biome lint/format + vtsls types; Prettier for Astro
  web = [
    biome
    vtsls
    astro-language-server
    prettier
    yaml-language-server
    vscode-langservers-extracted
  ];

  # PHP: PHPactor language services + PHP-CS-Fixer formatting
  php = [
    php
    phpactor
    phpPackages.php-cs-fixer
  ];

  # Nix (The Modern Stack)
  nix = [
    nixd
    alejandra
    statix
  ];

  # C/C++: clangd with its integrated clang-tidy checks; CMake formatted by
  # gersemi (cmake-format is unmaintained) and linted by cmakelint
  c = [
    clang-tools
    cppcheck
    neocmakelsp
    cmake-lint
    gersemi
  ];

  rust = [
    rust-analyzer
    cargo
    rustc
    rustfmt
    clippy
  ];

  zig = [
    zig
    zls
  ];

  solidity = [
    solc
    vscode-solidity-server # Includes Solhint; no separate linter process needed.
    foundry
  ];

  lua = [
    lua-language-server
    stylua
  ];

  # Shell: bash-language-server runs ShellCheck itself; shfmt formats
  shell = [
    bash-language-server
    shellcheck
    shfmt
  ];

  # Docker: language services + Dockerfile/ShellCheck best-practice checks
  docker = [
    dockerfile-language-server
    docker-compose-language-service
    hadolint
  ];
}
