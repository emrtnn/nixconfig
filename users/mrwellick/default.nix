{ config, pkgs, inputs, lib, ... }:
{
	home.username = "mrwellick";
	home.homeDirectory = "/home/mrwellick";
	home.stateVersion = "25.05";

	imports = [
		inputs.self.modules.home-manager.programs.git
	];

	home.packages = with pkgs; [
		brave
		eza
		rigrep
		fzf
		btop
	];

	xdg.enable = true;
	xdg.userDirs.enable = true;

	home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "brave";
  };
}
