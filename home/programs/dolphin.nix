{
  config,
  lib,
  pkgs,
  ...
}: let
  ini = pkgs.formats.ini {};
  # Gruvbox dark, shared by KDE's color scheme and the Qt platform palette.
  colors = {
    bg = "40,40,40";
    bg1 = "60,56,54";
    bg2 = "80,73,69";
    fg = "235,219,178";
    fg0 = "251,241,199";
    gray = "146,131,116";
    red = "251,73,52";
    green = "184,187,38";
    yellow = "215,153,33";
    blue = "131,165,152";
    purple = "211,134,155";
    aqua = "142,192,124";
    orange = "254,128,25";
  };
  colorSet = background: {
    BackgroundNormal = background;
    BackgroundAlternate = colors.bg1;
    ForegroundNormal = colors.fg;
    ForegroundInactive = colors.gray;
    ForegroundActive = colors.yellow;
    ForegroundLink = colors.blue;
    ForegroundVisited = colors.purple;
    ForegroundNegative = colors.red;
    ForegroundNeutral = colors.orange;
    ForegroundPositive = colors.green;
    DecorationFocus = colors.yellow;
    DecorationHover = colors.aqua;
  };
  kdeColors = {
    General.Name = "Gruvbox Dark";
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
  qtPalette = text: lib.concatStringsSep ", " (map qtColor (with colors; [
    text bg1 bg2 bg1 bg bg2 text fg0 text bg bg bg yellow bg blue purple bg1 bg bg1 fg gray yellow
  ]));
  palette = ini.generate "gruvbox-dark-qt.conf" {
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
in {
  home.packages = with pkgs.kdePackages; [
    dolphin
    ark
    kio-fuse
    ffmpegthumbs
    kdegraphics-thumbnailers
    konsole
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
        General.ColorScheme = "GruvboxDark";
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
          IconSize = 64;
          PreviewSize = 96;
        };
        PreviewSettings.Plugins = "directorythumbnail,imagethumbnail,jpegthumbnail,svgthumbnail,ffmpegthumbs,gsthumbnail";
        UiSettings.ColorScheme = "Gruvbox Dark";
      };
    };
  };

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications."inode/directory" = ["org.kde.dolphin.desktop"];
    };
    dataFile = {
      "color-schemes/GruvboxDark.colors".source = ini.generate "GruvboxDark.colors" kdeColors;
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
}
