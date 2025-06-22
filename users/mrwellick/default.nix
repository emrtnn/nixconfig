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


		inputs.hyprpanel.homeManagerModules.hyprpanel
	];

	home.packages = with pkgs; [
		brave
		eza
		ripgrep
		fzf
		btop
		mako
		libnotify
		rofi-wayland
		hyprpicker
		wl-clip-persist
	];

	xdg.enable = true;
	xdg.userDirs.enable = true;

	home.sessionVariables = {
		SHELL = "${pkgs.nushell}/bin/nu";
		BROWSER = "brave";
	};

	services.clipse = {
		enable = true;
	};

	programs.hyprpanel = {
		enable = true;
		systemd.enable = true;
		hyprland.enable = true;
	};

	services.swww.enable = true;

	xdg.configFile = {
		"hypr/hyprland.conf".source = config-files.hyprland.config;
		"rofy/config.rasi".source = config-files.rofi.configRasi;
	};

}
