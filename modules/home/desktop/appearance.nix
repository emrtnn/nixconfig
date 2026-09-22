{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    qt6Packages.qt6ct
    adw-gtk3
    nwg-look
  ];

  home.pointerCursor = {
    enable = true;
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4 = {
      inherit (config.gtk) theme iconTheme;
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };

  home.file = {
    "Pictures/Wallpapers" = {
      source = ../../../wallpapers;
      recursive = true;
    };

    ".face.png".source = ../../../assets/.face;
  };
}
