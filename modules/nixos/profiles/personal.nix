{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../base.nix
    ../users/impuremonad.nix
    ../desktop/base.nix
    ../security-lab.nix
    ../desktop/mango.nix
    ../gaming.nix
    # Match the shared fonts import depth so SilentSDDM's font directory keeps
    # its original precedence before the explicit desktop font collection.
    {imports = [inputs.silentSDDM.nixosModules.default];}
    inputs.sops-nix.nixosModules.sops
  ];

  boot = {
    loader = {
      systemd-boot.enable = false;
      limine.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelParams = lib.mkBefore [
      "quiet"
      "splash"
      "boot.initrd.verbose=false"
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

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 100;
  };

  networking = {
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
      wifi.powersave = false;
      insertNameservers = ["9.9.9.9" "149.112.112.112"];
    };

    nameservers = ["9.9.9.9" "149.112.112.112"];
    firewall = {
      enable = true;
      trustedInterfaces = ["tailscale0"];
      allowedUDPPorts = [41641];
    };
  };

  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    resolved = {
      enable = true;
      settings.Resolve = {
        DNSSEC = "true";
        Domains = ["~."];
        DNS = ["9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net"];
        FallbackDNS = ["9.9.9.9#dns.quad9.net" "149.112.112.112#dns.quad9.net"];
        DNSOverTLS = "true";
      };
    };

    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
      };
    };

    tailscale.enable = true;
  };

  programs = {
    ssh.startAgent = false;

    localsend = {
      enable = true;
      openFirewall = true;
    };

    silentSDDM = {
      enable = true;
      theme = "default";
      profileIcons.impuremonad = ../../../assets/.face;
    };

    gnupg.agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-curses;
      enableSSHSupport = true;

      settings = {
        default-cache-ttl = 7200;
        max-cache-ttl = 14400;
      };
    };
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    graphics.enable32Bit = true;
  };

  services.pipewire = {
    alsa.support32Bit = true;
    jack.enable = true;
  };

  users.users.impuremonad.extraGroups = ["gamemode"];

  system.autoUpgrade = {
    enable = true;
    dates = "weekly";
  };

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      extra-substituters = [
        "https://devenv.cachix.org"
        "https://noctalia.cachix.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
      ];

      extra-trusted-public-keys = [
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
    };
  };
}
