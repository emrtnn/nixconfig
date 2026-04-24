{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./fonts.nix
    inputs.silentSDDM.nixosModules.default
    inputs.sops-nix.nixosModules.sops
    ../../modules/desktop/niri.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = false;
      limine = {
        enable = true;
        # This host has a 196M EFI partition, so keeping multiple initrds
        # around under /boot/limine quickly exhausts the available space.
        maxGenerations = 2;
        extraEntries = ''
          /Windows 11
            protocol: efi_chainload
            image_path: boot():/EFI/Microsoft/Boot/bootmgfw.efi
        '';
      };
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      "quiet"
      "splash"
      "boot.initrd.verbose=false"
      "nvidia-drm.modeset=1"
    ];

    initrd = {
      enable = true;
      systemd.enable = true;
      verbose = false;
    };

    consoleLogLevel = 0;
    plymouth = {
      enable = true;
      font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
      theme = "splash";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["splash"];
        })
      ];
    };
  };

  zramSwap.memoryMax = {
    enable = true;
  };

  networking = {
    hostName = "monad";
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.powersave = false;
      insertNameservers = ["1.1.1.1" "1.0.0.1"];
    };

    nameservers = ["1.1.1.1" "1.0.0.1"];
    firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [41641];
    };
  };

  services = {
    resolved = {
      enable = true;
      settings = {
        Resolve = {
          DNSSEC = "false";
          Domains = ["~."];
          FallbackDNS = ["1.1.1.1" "1.0.0.1"];
          DNSOverTLS = "false";
        };
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    gnome.gnome-keyring.enable = true;

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      wayland.compositor = "kwin";
    };

    xserver.videoDrivers = ["nvidia"];

    tailscale = {
      enable = true;
    };

    gvfs.enable = true;
  };

  time.timeZone = "Europe/Madrid";

  i18n.defaultLocale = "en_US.UTF-8";

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

  programs = {
    silentSDDM = {
      enable = true;
      theme = "default";
      profileIcons.impuremonad = ../../assets/.face;
    };
    zsh.enable = true;
    dconf.enable = true;
    ssh.startAgent = false;
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      modesetting.enable = true;
      open = true;
      powerManagement.enable = true;
    };
  };

  # Hint Electron apps to use Wayland
  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    systemPackages = with pkgs; [
      bash
      vim
      wget
      git
      gcc
    ];
  };

  users = {
    users.impuremonad = {
      isNormalUser = true;
      description = "impuremonad";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      shell = pkgs.zsh;
    };
  };

  system = {
    autoUpgrade = {
      enable = true;
      dates = "weekly";
    };
    stateVersion = "25.11";
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      # Cachix
      substituters = [
        "https://devenv.cachix.org"
      ];

      trusted-substituters = [
        "https://devenv.cachix.org"
      ];

      trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    defaultSopsFormat = "yaml";
    age.keyFile = "/home/impuremonad/.config/sops/age/keys.txt";
  };
}
