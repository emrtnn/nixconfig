{ config, lib, pkgs, inputs, ... }:
{
	programs.nushell = {
		enable = true;
		configFile.source = inputs.self.config-files.nushell.configNu;

		extraConfig = ''
			$env.TRANSIENT_PROMPT_COMMAND = null
		'';
	};
}
