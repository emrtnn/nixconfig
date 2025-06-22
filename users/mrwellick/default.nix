{ pkgs, inputs, lib, config-files, ... }:
{

	_module.args = { inherit inputs config-files; };

	home.username = "mrwellick";
	home.homeDirectory = "/home/mrwellick";
	home.stateVersion = "25.05";

	imports = [
		../../modules/home-manager/programs/git.nix
		../../modules/home-manager/programs/nushell.nix
		../../modules/home-manager/programs/jujutsu.nix
		../../modules/home-manager/programs/ghostty.nix
		../../modules/home-manager/programs/starship.nix
		../../modules/home-manager/programs/helix.nix
		../../modules/home-manager/programs/yazi.nix
	];

	home.packages = with pkgs; [
		brave
		eza
		ripgrep
		fzf
		btop
		libnotify
		walker
		wl-clip-persist

		hyprpicker
		hyprshot
	];

	xdg.enable = true;
	xdg.userDirs.enable = true;

	home.sessionVariables = {
		SHELL = "${pkgs.nushell}/bin/nu";
		BROWSER = "brave";
	};

	services.swww.enable = true;

	services.swaync = {
		enable = true;
	};

	programs.hyprlock = {
		enable = true;
	};

	services.hypridle = {
		enable = true;
	};

	xdg.configFile = {
		"hypr/hyprland.conf".source = config-files.hyprland.config;
		"rofy/config.rasi".source = config-files.rofi.configRasi;
		"waybar/config".source = config-files.waybar.config;
		"waybar/style.css".source = config-files.waybar.styleCss;
		"hypr/hyprlock.conf".source = config-files.hyprlock.config;
		"hypr/mocha.conf".source = config-files.hyprlock.mochaTheme;
		"hypr/hypridle.conf".source = config-files.hypridle.config;
		"walker/config.toml".source = config-files.walker.configToml;
		"walker/themes/default.css".source = config-files.walker.defaultCss;
		"walker/themes/default.toml".source = config-files.walker.defaultToml;
		"walker/themes/default_window.toml".source = config-files.walker.defaultWindowToml;
	};

}
