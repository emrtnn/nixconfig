{ config, pkgs, inputs, lib, ... }:
{
	home.username = "mrwellick";
	home.homeDirectory = "/home/mrwellick";
	home.stateVersion = "25.05";

	imports = [
		../../modules/home-manager/programs/git.nix
		../../modules/home-manager/programs/nushell.nix
		../../modules/home-manager/programs/jujutsu.nix
	];

	home.packages = with pkgs; [
		brave
		eza
		ripgrep
		fzf
		btop
	];

	xdg.enable = true;
	xdg.userDirs.enable = true;

	home.sessionVariables = {
		SHELL = "${pkgs.nushell}/bin/nu";
    EDITOR = "nvim";
    BROWSER = "brave";
  };
}
