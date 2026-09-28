{inputs, ...}: {
  imports = [inputs.home-manager.nixosModules.home-manager];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs;};
    backupFileExtension = "backup";
    overwriteBackup = true;
    sharedModules = [
      ../home/session.nix
      ../home/cli.nix
      ../home/programs/bat.nix
      ../home/programs/glow.nix
      ../home/programs/tuicr.nix
      ../home/programs/carapace.nix
      ../home/programs/starship.nix
      ../home/programs/yazi.nix
      ../home/programs/zoxide.nix
      ../home/programs/git.nix
      ../home/programs/zsh.nix
      ../home/programs/fzf.nix
      ../home/programs/jujutsu.nix
      ../home/programs/nvim.nix
    ];
  };
}
