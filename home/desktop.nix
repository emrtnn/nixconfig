{
  pkgs,
  inputs,
  ...
}: {
  home.username = "impuremonad";
  home.homeDirectory = "/home/impuremonad";
  home.stateVersion = "25.11";

  imports = [
    inputs.nvf.homeManagerModules.default
    ../modules/programs/carapace.nix
    ../modules/programs/kitty.nix
    ../modules/programs/nushell.nix
    ../modules/programs/starship.nix
    ../modules/programs/vim.nix
    ../modules/programs/yazi.nix
    ../modules/programs/zoxide.nix
    ../modules/programs/git.nix
    ../modules/programs/fastfetch.nix
    ../modules/programs/opencode.nix
    ../modules/programs/tmux.nix
    ../modules/programs/direnv.nix
    ../modules/programs/zsh.nix
    ../modules/programs/vesktop.nix
    ../modules/programs/btop.nix
    ../modules/programs/fzf.nix
  ];

  home.packages = with pkgs; [
    bat
    lazygit
    ripgrep
    fd
    tree
    brave
    google-chrome
    nautilus
    bitwarden-desktop
    (inputs.quickshell.packages.${pkgs.system}.default.withModules (with pkgs.qt6; [
      qtsvg
      qt5compat
      qtimageformats
    ]))
  ];

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    BROWSER = "brave";
  };

  home.file."Pictures/Wallpapers" = {
    source = ../wallpapers;
    recursive = true;
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;
    gtk.enable = true;
    x11.enable = true;
  };

  dconf = {
    settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  services.gnome-keyring = {
    enable = true;
    components = [
      "secrets"
      "ssh"
    ];
  };

  services.cliphist = {
    enable = true;
    allowImages = true;
  };
}
