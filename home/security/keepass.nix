{
  config,
  lib,
  pkgs,
  ...
}: let
  devices = {
    # arpano.id = "XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX";
    argos.id = "XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX";
    iphone.id = "XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX-XXXXXXX";
  };

  keepassxcSettings = {
    GUI = {
      CheckForUpdates = false;
      ShowTrayIcon = true;
      MinimizeToTray = true;
      MinimizeOnClose = true;
    };
    Security.LockDatabaseIdleSeconds = 300;
    Browser = {
      Enabled = true;
      UpdateBinaryPath = false;
    };
  };
in {
  programs.keepassxc.enable = true;

  home.activation.keepassxcSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run install -D -m600 ${(pkgs.formats.ini {}).generate "keepassxc.ini" keepassxcSettings} \
      ${config.xdg.configHome}/keepassxc/keepassxc.ini
  '';

  # Tells Helium where KeePassXC is, for the KeePassXC-Browser extension.
  # (LibreWolf gets the same through its wrapper, see the hosts' home.nix.)
  xdg.configFile."net.imput.helium/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json".source = "${config.programs.keepassxc.package}/etc/chromium/native-messaging-hosts/org.keepassxc.keepassxc_browser.json";

  services.syncthing = {
    enable = true;
    settings = {
      options.urAccepted = -1; # no anonymous usage reports
      inherit devices;
      folders.keepass = {
        path = "~/Passwords"; # Syncthing creates it if missing
        devices = builtins.attrNames devices; # share with every device above
        # When a sync replaces the database, keep the old copy in
        # ~/Passwords/.stversions for 90 days.
        versioning = {
          type = "staggered";
          params.maxAge = toString (90 * 24 * 60 * 60);
        };
      };
    };
  };
}
