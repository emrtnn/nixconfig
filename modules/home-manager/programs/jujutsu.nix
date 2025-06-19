{ config, pkgs, lib, inputs, ... }:
{
	programs.jujutsu = {
		enable = true;
	};

	xdg.configFiles."jujutsu/config.toml".source = inputs.self.config-files.jujutsu.configToml;

}
