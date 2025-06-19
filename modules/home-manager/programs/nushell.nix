{ config, lib, pkgs, inputs, configFiles, ... }:
{
	programs.nushell = {
		enable = true;
		configFile.source = configFiles.nushell.configNu;

		extraConfig = ''
			$env.TRANSIENT_PROMPT_COMMAND = null
		'';
	};
}
