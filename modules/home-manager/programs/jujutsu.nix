{ config, pkgs, lib, inputs, configFiles, ... }:
{
	programs.jujutsu = {
		enable = true;
	};

	xdg.configFiles."jujutsu/config.toml".source = inputs.self.config-files.jujutsu.configToml;

}
