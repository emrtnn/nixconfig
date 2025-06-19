{ config, pkgs, inputs, lib, configFiles, ... }:
{
	home.username = "mrwellick";
	home.homeDirectory = "/home/mrwellick";
	home.stateVersion = "25.05";

	imports = [
		inputs.self.modules.home-manager.programs.git
		inputs.self.modules.home-manager.programs.nushell { inherit configFiles; }
		inputs.self.modules.home-manager.programs.jujutsu { inherit configFiles; }
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
