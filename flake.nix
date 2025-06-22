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
  };

	outputs = { self, nixpkgs, home-manager, ... } @inputs:
		let
			lib = nixpkgs.lib;

			supportedSystems = [
				"x86_64-linux"
			];

			forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

			myOverlays = [
				inputs.jujutsu.overlays.default
				inputs.yazi.overlays.default
			];

			packagesWithOverlays = forAllSystems (system: import nixpkgs {
				inherit system;
				overlays = myOverlays;
				config = {
					allowUnfree = true;
				};
			});

			config-files = {
				hyprland = {
					config = ./config-files/hypr/hyprland.conf;
				};
				rofi = {
					configRasi = ./config-files/rofi/config.rasi;
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
				};
				hyprlock = {
					config = ./config-files/hypr/hyprlock.conf;
					mochaTheme = ./config-files/hypr/mocha.conf;
				};
				hypridle = {
					config = ./config-files/hypr/hypridle.conf;
				};
				walker = {
					configToml = ./config-files/walker/config.toml;
					defaultCss = ./config-files/walker/themes/default.css;
					defaultToml = ./config-files/walker/themes/default.toml;
					defaultWindowToml = ./config-files/walker/themes/default_window.toml;
				};
			};
		in
		{
			nixosConfigurations = {
				"desktop" = nixpkgs.lib.nixosSystem {
					system = "x86_64-linux";
					modules = [
						./hosts/desktop

						home-manager.nixosModules.home-manager {
							home-manager.useGlobalPkgs = true;
							home-manager.useUserPackages = true;
							home-manager.users.mrwellick = import ./users/mrwellick {
								pkgs = packagesWithOverlays.x86_64-linux;
								inherit inputs lib;
								config-files = config-files;
							};
						}
					];
					specialArgs = { inherit inputs self config-files; };
				};
			};
		};
}
