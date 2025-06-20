{ config-files, pkgs, lib, ... }:
{
	xdg.configFile."ghostty/config".source = config-files.ghostty.config;

	programs.ghostty = {
		enable = true;
	};
}
