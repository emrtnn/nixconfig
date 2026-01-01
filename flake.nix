{
  description = "Hyprland + Quickshell + Nixos";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
    yazi.url = "github:sxyazi/yazi";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    hyprland,
    nvf,
    yazi,
    ...
  } @ inputs: {
    nixosConfigurations.monad = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.impuremonad = import ./home;
            extraSpecialArgs = {inherit inputs;};
            backupFileExtension = "backup";
          };
        }
      ];
    };
  };
}
