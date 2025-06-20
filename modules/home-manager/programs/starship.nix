{ config-files, pkgs, ... }:
{
	programs.starship = {
		enable = true;
		enableNushellIntegration = true;
		enableTransience = true;
	};

	xdg.configFile."starship.toml".source = config-files.starship.config;
}
