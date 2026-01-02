{pkgs, ...}: {
  imports = [
    ../programs/carapace.nix
    ../programs/kitty.nix
    ../programs/nushell.nix
    ../programs/starship.nix
    ../programs/vim.nix
    ../programs/yazi.nix
    ../programs/zoxide.nix
    ../programs/git.nix
    ../programs/fastfetch.nix
    ../programs/opencode.nix
    ../programs/tmux.nix
    ../programs/direnv.nix
  ];
}
