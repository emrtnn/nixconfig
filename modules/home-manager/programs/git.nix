{ config, pkgs, ... }:
{
	programs.git = {
		enable = true;
		userName = "tyrellw3llick";
		userEmail = "enriquemartin1402@gmail.com";
		extraConfig = {
				init.defaultBranch = "master";
				pull.rebase = true;
				core.editor = "hx";
		};
	};
}
