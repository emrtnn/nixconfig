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

		../../modules/home-manager/developer/rust.nix
		../../modules/home-manager/developer/go.nix
		../../modules/home-manager/developer/python.nix
		../../modules/home-manager/developer/node.nix
		
		inputs.walker.homeManagerModules.default
	];

	home.packages = with pkgs; [
		brave
		eza
		ripgrep
		fzf
		btop
		libnotify
		wl-clipboard
		hyprpicker
		hyprshot
		playerctl
		telegram-desktop
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

	services.clipse = {
		enable = true;
		allowDuplicates = false;
	};

	programs.walker = {
		enable = true;
		runAsService = true;
		config = {
			search.placeholder = "Search...";
			websearch.prefix = "?";
		};
	};

	programs.vesktop = {
		enable = true;
	};

	xdg.configFile = {
		"hypr/hyprland.conf".source = config-files.hyprland.config;
		"waybar/config".source = config-files.waybar.config;
		"waybar/style.css".source = config-files.waybar.styleCss;
		"waybar/tokyo-night.css".source = config-files.waybar.tokyoNightCss;
		"hypr/hyprlock.conf".source = config-files.hyprlock.config;
		"hypr/mocha.conf".source = config-files.hyprlock.mochaTheme;
		"hypr/hypridle.conf".source = config-files.hypridle.config;
	};

	home.file.".wallpapers/kanagawa.jpg" = {
    source = config-files.wallpapers.kanagawa;
  };
}
