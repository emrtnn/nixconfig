{pkgs, ...}: {
  imports = [
    ../../modules/home/programs/carapace.nix
    ../../modules/home/programs/starship.nix
    ../../modules/home/programs/yazi.nix
    ../../modules/home/programs/zoxide.nix
    ../../modules/home/programs/git.nix
    ../../modules/home/programs/zsh.nix
    ../../modules/home/programs/fzf.nix
    ../../modules/home/programs/jujutsu.nix
    ../../modules/home/programs/nvim.nix
  ];

  home.packages = with pkgs; [
    bat
    glow
    tuicr
    lazygit
    ripgrep
    fd
    dnsutils
    duckdb
    btop
    gh
    devenv
    uv
    python3
    unzip
    ninja
  ];

  xdg.configFile = {
    "bat/config".source = ../../dotfiles/bat/config;
    "glow/glow.yml".source = ../../dotfiles/glow/glow.yml;
    "tuicr/config.toml".source = ../../dotfiles/tuicr/config.toml;
  };
}
