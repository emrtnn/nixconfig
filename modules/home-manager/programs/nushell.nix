{ config-files, ... }:
{
	programs.nushell = {
		enable = true;
		configFile.source = config-files.nushell.configNu;
	};
}
