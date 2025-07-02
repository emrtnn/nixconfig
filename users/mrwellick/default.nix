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
		postgresql
		dbeaver-bin
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
					on-timeout = "hyrctl dispatch dpms off";
					on-resume = "hyprctl dipatch dpms on";
				}
			];
		};
	};

	services.clipse = {
		enable = true;
		allowDuplicates = false;
	};

	programs.wofi = {
		enable = true;
		settings = {
			location = "center";
			show ="drun";
	 		prompt ="Search...";
	 		allow_markup = true;
	 		allow_images = true;
	 		image_size = 40;
	 		orientation = "vertical";
	 		content_halign = "fill";
	 		halign = "fill";
	 		insensitive = true;
	 		gtk_dark = true;
	 		no_actions = true;
	 		filter_rate = 100;
	 		width = 600;
	 		height = 350;
		};
		style = ''
			@define-color	selected-text  #88C0D0;
			@define-color	text  #D8DEE9;
			@define-color	base  #2E3440;

			* {
			  font-family: 'CaskaydiaMono Nerd Font', monospace;
			  font-size: 18px;
			}

			window {
			  margin: 0px;
			  padding: 20px;
			  background-color: @base;
			}

			#inner-box {
			  margin: 0;
			  padding: 0;
			  border: none;
			  background-color: @base;
			}

			#outer-box {
			  margin: 0;
			  padding: 20px;
			  border: none;
			  background-color: @base;
			}

			#scroll {
			  margin: 0;
			  padding: 0;
			  border: none;
			  background-color: @base;
			}

			#input {
			  margin: 0;
			  padding: 10px;
			  border: none;
			  background-color: @base;
			  color: @text;
			}

			#input:focus {
			  outline: none;
			  box-shadow: none;
			  border: none;
			}

			#text {
			  margin: 5px;
			  border: none;
			  color: @text;
			}

			#entry {
			  background-color: @base;
			}

			#entry:selected {
			  outline: none;
			  border: none;
			}

			#entry:selected #text {
			  color: @selected-text;
			}

			#entry image {
			  -gtk-icon-transform: scale(0.7);
			}
		'';
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
