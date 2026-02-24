{
  description = "Hyprland + Quickshell + Nixos";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-25.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    yazi.url = "github:sxyazi/yazi";
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    overlays = [
      (final: prev: {
        helium = prev.callPackage ./pkgs/helium.nix {};
        python313Packages = prev.python313Packages.overrideScope (pyFinal: pyPrev: {
          picosvg = pyPrev.picosvg.overridePythonAttrs (old: {
            patches = (old.patches or []) ++ [
              (prev.fetchpatch {
                url = "https://github.com/googlefonts/picosvg/commit/885ee64b75f526e938eb76e09fab7d93e946a355.patch";
                hash = "sha256-fR3FfnEPHwSO1rMtmQEr1pyvByTx8T53FxSpuAKWIjw=";
              })
            ];
          });
        });
      })
    ];
  in {
    nixosConfigurations.monad = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        {nixpkgs.overlays = overlays;}
        ./hosts/desktop/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.impuremonad = import ./home/desktop.nix;
            extraSpecialArgs = {inherit inputs;};
            backupFileExtension = "backup";
          };
        }
      ];
    };

    nixosConfigurations.arpano = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        {nixpkgs.overlays = overlays;}
        ./hosts/workstation/configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.impuremonad = import ./home/desktop.nix;
            extraSpecialArgs = {inherit inputs;};
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
