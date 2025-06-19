{ config, pkgs, inputs, lib, ... }:

{
	imports = [
		./hardware-configuration.nix
		./fonts
		../../modules/common
		../../modules/desktop
	];

	networking.hostName = "mrwellick-nixos";

	time.timeZone = "Europe/Madrid";
	i18n.defaultLocale = "es_ES.UTF-8";
	i18n.extraLocaleSettings = {
		LC_ADDRESS = "es_ES.UTF-8";
		LC_IDENTIFICATION = "es_ES.UTF-8";
		LC_MEASUREMENT = "es_ES.UTF-8";
		LC_MONETARY = "es_ES.UTF-8";
		LC_NAME = "es_ES.UTF-8";
		LC_NUMERIC = "es_ES.UTF-8";
		LC_PAPER = "es_ES.UTF-8";
	};

	boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

	nix.settings.experimental-features = [ "flakes" "nix-command" ];
  nix.settings.extra-substituters = [
    "https://hyprland.cachix.org/"
    "https://nix-community.cachix.org/"
  ];

	nix.settings.builders-use-substitutes = true;
  nix.settings.trusted-users = [ "root" "@wheel" ];

	services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

	services.NetworkManager.enable = true;

	nix.gc = {
		automatic = true;
		interval = {
			days = 7;
		};
		options = "--delete-older-than 7d";
	};

	system.stateVersion = "25.05";
}
