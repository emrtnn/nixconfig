{
  description = "Mr. Wellick Nixos Configuration";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

		jujutsu.url = "github:martinvonz/jj";
		yazi.url = "github:sxyazi/yazi";
		helix.url = "github:helix-editor/helix";
		walker.url = "github:abenz1267/walker";
		rust-overlay.url = "github:oxalica/rust-overlay";

  };

	outputs = { self, nixpkgs, home-manager, ... } @inputs:
		let
			system = "x86_64-linux";
			pkgs = import nixpkgs {
				system = system;
				config.allowUnfree = true;
				overlays = [
					inputs.jujutsu.overlays.default
					inputs.yazi.overlays.default
					inputs.rust-overlay.overlays.default
				];
			};


			config-files = {
				hyprland = {
					config = ./config-files/hypr/hyprland.conf;
				};
				jujutsu = {
					configToml = ./config-files/jujutsu/config.toml;
				};
				nushell = {
					configNu = ./config-files/nushell/config.nu;
				};
				ghostty = {
					config = ./config-files/ghostty/config;
				};
				starship = {
					config = ./config-files/starship/starship.toml;
				};
				yazi = {
					initLua = ./config-files/yazi/init.lua;
				};
				waybar = {
					config = ./config-files/waybar/config;
					styleCss = ./config-files/waybar/style.css;
					tokyoNightCss = ./config-files/waybar/tokyo-night.css;
				};
				hyprlock = {
					config = ./config-files/hypr/hyprlock.conf;
					mochaTheme = ./config-files/hypr/mocha.conf;
				};
				wallpapers = {
					mountain = ./config-files/wallpapers/mountain_wp.jpeg;
				};
				cursors = {
					breezeBlack = ./config-files/cursor-themes/BreezeX-Black-hyprcursor;
				};
			};
		in
		{

			nixpkgs = {
				system = system;
				config.allowUnfree = true;
			};

			nixosConfigurations = {
				"desktop" = nixpkgs.lib.nixosSystem {

					system = system;

					specialArgs = { inherit inputs config-files; };

					modules = [

						./hosts/desktop

						home-manager.nixosModules.home-manager {
							home-manager.extraSpecialArgs = { inherit inputs pkgs config-files; };
							home-manager.sharedModules = [ inputs.walker.homeManagerModules.default ];
							home-manager.users.mrwellick = import ./users/mrwellick;
						}
					];
				};
			};
		};
}
