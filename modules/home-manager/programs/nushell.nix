{ config-files, lib, pkgs, inputs, ... }:
{
	programs.nushell = {
		enable = true;
		#configFile.source = config-files.nushell.configNu;

		extraConfig = ''
			$env.TRANSIENT_PROMPT_COMMAND = null
		'';
	};
}
