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
		LC_TELEPHONE = "es_ES.UTF-8";
		LC_TIME = "es_ES.UTF-8";
	};
	hardware = {
		graphics.enable = true;
	  nvidia.modesetting.enable = true;
	};

	services.xserver.xkb = {
		layout = "es";
		variant = "";
	};
	security.rtkit.enable = true;
	services.pipewire = {
	  enable = true;
	  alsa.enable = true;
	  alsa.support32Bit = true;
	  pulse.enable = true;
	  jack.enable = true;
	};

	console.keyMap = "es";

	boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

	nix.settings.experimental-features = [ "flakes" "nix-command" ];
  nix.settings.extra-substituters = [
    "https://hyprland.cachix.org/"
    "https://nix-community.cachix.org/"
		"https://cache.nixos.org"
		"https://helix.cachix.org"
  ];
	nix.settings.extra-trusted-public-keys = [
		"helix.cachix.org-1:ejp9KQpR1FBI2onstMQ34yogDm4OgU2ru6lIwPvuCVs="
	];

	nix.settings.builders-use-substitutes = true;
  nix.settings.trusted-users = [ "root" "@wheel" ];

  programs.ssh = {
    startAgent = true;
  };

	services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  users.users.mrwellick = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
      "video"
      "audio"
      "input"
    ];
    shell = pkgs.nushell;
  };

	networking.networkmanager.enable = true;

	nix.gc = {
		automatic = true;
		dates =	"weekly";
          	options = "--delete-older-than 7d";
	};

	system.stateVersion = "25.05";
}
