{config, ...}: let
  # Caelus, shared by KDE's color scheme and the Qt platform palette.
  c = config.theme.caelus;
in {
  flake.modules.homeManager.desktop = {
    config,
    lib,
    pkgs,
    ...
  }: let
    ini = pkgs.formats.ini {};
    rgb = hex: lib.concatMapStringsSep "," (offset: toString (lib.fromHexString (builtins.substring offset 2 hex))) [1 3 5];
    colors = builtins.mapAttrs (_: rgb) {
      bg = c.bg;
      bg1 = c.gray1;
      bg2 = c.gray3;
      fg = c.fg;
      fg0 = c.fg;
      gray = c.gray6;
      red = c.red;
      green = c.green;
      accent = c.orange;
      blue = c.blue;
      purple = c.magenta;
      aqua = c.orangeLight;
      neutral = c.yellow;
    };
    colorSet = background: {
      BackgroundNormal = background;
      BackgroundAlternate = colors.bg1;
      ForegroundNormal = colors.fg;
      ForegroundInactive = colors.gray;
      ForegroundActive = colors.accent;
      ForegroundLink = colors.blue;
      ForegroundVisited = colors.purple;
      ForegroundNegative = colors.red;
      ForegroundNeutral = colors.neutral;
      ForegroundPositive = colors.green;
      DecorationFocus = colors.accent;
      DecorationHover = colors.aqua;
    };
    kdeColors = {
      General.Name = "Caelus";
      "ColorEffects:Inactive".Enable = false;
      "Colors:View" = colorSet colors.bg;
      "Colors:Window" = colorSet colors.bg;
      "Colors:Button" = colorSet colors.bg1;
      "Colors:Selection" = (colorSet colors.bg2) // {ForegroundNormal = colors.fg0;};
      "Colors:Tooltip" = colorSet colors.bg1;
      "Colors:Complementary" = colorSet colors.bg1;
      "Colors:Header" = colorSet colors.bg1;
    };
    qtColor = rgb:
      "#" + lib.concatMapStrings (component: lib.fixedWidthString 2 "0" (lib.toHexString (lib.toInt component))) (lib.splitString "," rgb);
    qtPalette = text:
      lib.concatStringsSep ", " (map qtColor (with colors; [
        text
        bg1
        bg2
        bg1
        bg
        bg2
        text
        fg0
        text
        bg
        bg
        bg
        accent
        bg
        blue
        purple
        bg1
        bg
        bg1
        fg
        gray
        accent
      ]));
    palette = ini.generate "caelus-qt.conf" {
      ColorScheme = {
        active_colors = qtPalette colors.fg;
        inactive_colors = qtPalette colors.fg;
        disabled_colors = qtPalette colors.gray;
      };
    };
    yaziTerminal =
      if config.programs.foot.enable
      then "${lib.getExe config.programs.foot.package} --app-id monad.yazi -e"
      else "${lib.getExe config.programs.kitty.package} --class monad.yazi -e";
    kdeTerminal =
      if config.programs.foot.enable
      then {
        app = "foot";
        service = "foot.desktop";
      }
      else {
        app = "kitty";
        service = "kitty.desktop";
      };
  in {
    home.packages = with pkgs.kdePackages; [
      dolphin
      ark
      kio-fuse
      ffmpegthumbs
      kdegraphics-thumbnailers
    ];

    # Retain qt6ct on both Mango and bspwm; no Plasma session is required.
    qt = {
      enable = true;
      platformTheme = {
        name = "qt6ct";
        package = pkgs.qt6Packages.qt6ct;
      };
      style.name = "breeze";
      qt6ctSettings = {
        Appearance = {
          style = "breeze";
          icon_theme = "Papirus-Dark";
          custom_palette = true;
          color_scheme_path = "${palette}";
          standard_dialogs = "xdgdesktopportal";
        };
        Fonts = {
          general = ''"Noto Sans,11"'';
          fixed = ''"JetBrainsMono Nerd Font Mono,11"'';
        };
      };

      # Merge preferences at activation rather than symlinking dolphinrc read-only:
      # Dolphin must still be able to save tabs, window geometry and panel layout.
      kde.settings = {
        kdeglobals = {
          General = {
            ColorScheme = "Caelus";
            TerminalApplication = kdeTerminal.app;
            TerminalService = kdeTerminal.service;
          };
          Icons.Theme = "Papirus-Dark";
          KDE.SingleClick = false;
        };
        dolphinrc = {
          General = {
            RememberOpenedTabs = true;
            OpenExternallyCalledFolderInNewTab = true;
            AlwaysShowTabBar = true;
            ShowFullPath = true;
            ShowToolTips = true;
            ShowZoomSlider = true;
            BrowseThroughArchives = true;
          };
          IconsMode = {
            IconSize = 48;
            PreviewSize = 64;
          };
          PreviewSettings.Plugins = "directorythumbnail,imagethumbnail,jpegthumbnail,svgthumbnail,ffmpegthumbs,gsthumbnail";
          UiSettings.ColorScheme = "Caelus";
        };
      };
    };

    xdg = {
      mimeApps = {
        enable = true;
        defaultApplications."inode/directory" = ["org.kde.dolphin.desktop"];
      };
      dataFile = {
        "color-schemes/Caelus.colors".source = ini.generate "Caelus.colors" kdeColors;
        "kio/servicemenus/open-in-yazi.desktop" = {
          executable = true;
          text = ''
            [Desktop Entry]
            Type=Service
            MimeType=inode/directory;
            Actions=openYazi;
            X-KDE-Protocols=file
            X-KDE-RequiredNumberOfUrls=1
            X-KDE-Priority=TopLevel

            [Desktop Action openYazi]
            Name=Open in Yazi
            Icon=utilities-terminal
            Exec=${yaziTerminal} ${lib.getExe config.programs.yazi.package} %f
          '';
        };
      };
    };
  };
}
