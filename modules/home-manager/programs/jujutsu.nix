{ config-files, ... }:
{
	programs.jujutsu = {
		enable = true;
	};

	xdg.configFile."jujutsu/config.toml".source = config-files.jujutsu.configToml;

}
