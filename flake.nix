{
  description = "Nixos Configuration";

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
    rust-overlay.url = "github:oxalica/rust-overlay";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    walker.url = "github:abenz1267/walker";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      overlays = with inputs; [
        jujutsu.overlays.default
        yazi.overlays.default
        helix.overlays.default
        rust-overlay.overlays.default
        neovim-nightly-overlay.overlays.default
      ];

      pkgs = import nixpkgs {
        system = system;
        config.allowUnfree = true;
        overlays = overlays;
      };

      config-files = {
        hyprland = {
          config = ./config-files/hypr/hyprland.conf;
        };
        jujutsu = {
          configToml = ./config-files/jj/config.toml;
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
          theme = ./config-files/yazi/theme.toml;
        };
        waybar = {
          config = ./config-files/waybar/config.jsonc;
          styleCss = ./config-files/waybar/style.css;
          kanagawaCss = ./config-files/waybar/kanagawa.css;
        };
        hyprlock = {
          config = ./config-files/hypr/hyprlock.conf;
        };
        hypridle = {
          config = ./config-files/hypr/hypridle.conf;
        };
        wallpapers = ./config-files/wallpapers;
        cursors = {
          breezeBlack = ./config-files/cursor-themes/BreezeX-Black-hyprcursor;
        };
        btop = {
          config = ./config-files/btop/btop.conf;
          theme = ./config-files/btop/btop.theme;
        };
        nvim = ./config-files/nvim;
      };
    in
    {

      nixpkgs = {
        system = system;
        config.allowUnfree = true;
        overlays = overlays;
      };

      nixosConfigurations = {
        "desktop" = nixpkgs.lib.nixosSystem {

          system = system;

          specialArgs = { inherit inputs config-files; };

          modules = [

            ./hosts/desktop

            home-manager.nixosModules.home-manager
            {
              home-manager.extraSpecialArgs = { inherit inputs pkgs config-files; };
              home-manager.users.mrwellick = import ./users/mrwellick;
            }
          ];
        };
      };
    };
}
