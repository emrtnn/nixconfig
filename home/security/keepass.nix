{
  config,
  lib,
  pkgs,
  ...
}: let
  devices = {
    arpano.id = "2HLCBNJ-2YMRD4N-XBKI24V-66UKFFI-LGLQ7DX-4L7TRAI-LVJOGIV-4GT4KQU";
    argos.id = "LZHI3UK-TXAPA6S-ZJUGUKO-KABWDVY-A63NUT7-NYGK5JI-CP5KQ4W-LDDRSQL";
    iphone.id = "YDRMSHL-36ZABJ3-LB2D3WR-IVSEDGA-ZPPOUPG-6KYQXEL-KVBGIY2-DTIUTQX";
    monad.id = "EAH6VG5-627GGZZ-7DWKN2I-J7H6L6W-SANERXC-CGTJCHS-EMLNTLI-5XYKRA6";
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
