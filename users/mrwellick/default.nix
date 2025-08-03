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
		../../modules/home-manager/programs/direnv.nix
	];

	home.packages = with pkgs; [
		cachix
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
		hypridle
		hyprlock
		gparted
		tree
		evince
		localsend
		ripgrep
		libreoffice
		claude-code
		smile
		neovim
	];

	xdg.enable = true;
	xdg.userDirs.enable = true;

	xdg.mimeApps = {
		enable = true;
		defaultApplications = {
			"application/pdf" = "org.gnome.Evince.desktop";
		};
	};

	home.sessionVariables = {
		SHELL = "${pkgs.nushell}/bin/nu";
		BROWSER = "brave";
	};

	services.swww.enable = true;

	services.swaync = {
		enable = true;
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
