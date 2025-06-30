{ pkgs, config-files, ... }:
{

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
		../../modules/home-manager/programs/fastfetch.nix
		../../modules/home-manager/programs/mtp.nix
		../../modules/home-manager/programs/github-cli.nix
	];

	home.packages = with pkgs; [
		nautilus
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
		hyperfine
		flamegraph
		zip
		unzip
		calibre
		mdbook
		keepass
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
		settings = {
			listener = [
				{
					timeout = 180;
					on-timeout = ''notify-send "Hyprland Idle" "Session is about to lock due to inactivity."'';
				}

				{
					timeout = 300;
					on-timeout = "pidof hyprlock || hyprlock";
				}

				{
					timeout = 360;
					on-timeout = "systemctl suspend";
				}
			];
		};
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
	};

	home.file = {
		# Wallpapers
		".wallpapers/mountain_wp.jpeg" = {
		  source = config-files.wallpapers.mountain;
		};

		# Cursor styles
		".local/share/icons/BreezeX-Black-hyprcursor" = {
			source = config-files.cursors.breezeBlack;
		};
	};
}
