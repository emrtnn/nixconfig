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
  };

	outputs = { self, nixpkgs, home-manager, ... } @inputs:
		let
			supportedSystems = [
				"x86_64-linux"
			];

			forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

			myOverlays = [
				inputs.jujutsu.overlays.default
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
					hyprland.conf = ./config-files/hyprland/hyprland.conf;
				};
				waybar = {
					config = ./config-files/waybar/config;
					style.css = ./config-files/waybar/style.css;
				};
				jujutsu = {
					configToml = ./config-files/jujutsu/config.toml;
				};
				nushell = {
					configNu = ./config-files/nushell/config.nu;
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
								inherit config inputs;
								configFiles = config-files;
							};
						}
					];
					specialArgs = { inherit inputs self config-files; };
				};
			};
		};
}
