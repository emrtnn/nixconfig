{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations.argos = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [base desktop bspwm vmware-guest argos];
  };

  flake.modules.nixos.argos = {
    imports = [
      # Required: the file generated inside the actual installed VMware guest.
      ./_hardware.nix
    ];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = false;
    };

    # Fresh UEFI VMware installation; device mappings come only from hardware.
    boot.loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 5;
      efi.canTouchEfiVariables = true;
    };

    system.stateVersion = "26.11";

    networking = {
      hostName = "argos";
      networkmanager.enable = true;
      firewall = {
        enable = true;
        allowedTCPPorts = [80 443];
      };
      # Lab hosts. /etc/hosts is a writable copy (see environment.etc.hosts.mode),
      # so ad-hoc entries can be added with `sudo` and are reset on rebuild.
      extraHosts = ''
        10.129.158.16 nexus.htb
      '';
    };

    # Retain the installer-created password database; no declarative credentials.
    users.mutableUsers = true;
  };

  flake.modules.homeManager.argos = {
    home.stateVersion = "26.05";

    xdg.mimeApps.defaultApplications = {
      "application/pdf" = "org.gnome.Evince.desktop";
      "x-scheme-handler/tg" = "org.telegram.desktop.desktop";
      "x-scheme-handler/tonsite" = "org.telegram.desktop.desktop";
      "x-scheme-handler/sgnl" = "signal.desktop";
      "x-scheme-handler/signalcaptcha" = "signal.desktop";
    };
  };
}
