{
  pkgs,
  inputs,
  config,
  ...
}: let
  stablePkgs = import inputs.nixpkgs-stable {
    inherit (pkgs.stdenv.hostPlatform) system;
    config.allowUnfree = true;
  };
in {
  home = {
    username = "impuremonad";
    homeDirectory = "/home/impuremonad";
    stateVersion = "25.11";
  };

  imports = [
    inputs.nvf.homeManagerModules.default
    inputs.noctalia.homeModules.default
    ../modules/programs/carapace.nix
    ../modules/desktop/kitty.nix
    ../modules/programs/nushell.nix
    ../modules/programs/starship.nix
    ../modules/programs/helix.nix
    ../modules/programs/yazi.nix
    ../modules/programs/zoxide.nix
    ../modules/programs/git.nix
    ../modules/programs/opencode.nix
    ../modules/programs/pi.nix
    ../modules/programs/tmux.nix
    ../modules/programs/direnv.nix
    ../modules/programs/zsh.nix
    ../modules/programs/vesktop.nix
    ../modules/programs/fzf.nix
    ../modules/desktop/swappy.nix
    ../modules/desktop/noctalia.nix
    ../modules/desktop/libreoffice.nix
    ../modules/programs/thunderbird.nix
    ../modules/programs/jujutsu.nix
    ../modules/programs/nvim.nix
  ];

  home.packages = with pkgs; [
    bat
    lazygit
    ripgrep
    fd
    dnsutils
    tree
    tree-sitter
    google-chrome
    helium
    telegram-desktop
    nautilus
    imv
    stablePkgs.bitwarden-desktop
    grim
    slurp
    gpu-screen-recorder
    hyprpicker
    ffmpeg
    mpv
    btop
    amp-cli
    wl-clipboard
    wtype
    codex
    evince
    obsidian
    gh
    devenv
    uv
    python3
    unzip
  ];

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    BROWSER = "helium";
    CHROME_PATH = "${pkgs.google-chrome}/bin/google-chrome";
  };

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      associations.added = {
        "text/html" = ["helium.desktop"];
        "x-scheme-handler/http" = ["helium.desktop"];
        "x-scheme-handler/https" = ["helium.desktop"];
        "x-scheme-handler/about" = "helium.desktop";
        "x-scheme-handler/unknown" = "helium.desktop";
        "application/xhtml+xml" = "helium.desktop";
      };
      defaultApplications = {
        "text/html" = "helium.desktop";
        "x-scheme-handler/http" = "helium.desktop";
        "x-scheme-handler/https" = "helium.desktop";
        "x-scheme-handler/about" = "helium.desktop";
        "x-scheme-handler/unknown" = "helium.desktop";
        "application/xhtml+xml" = "helium.desktop";
        "image/png" = "imv.desktop";
        "image/jpeg" = "imv.desktop";
        "image/gif" = "imv.desktop";
        "image/webp" = "imv.desktop";
        "image/svg+xml" = "imv.desktop";
        "image/bmp" = "imv.desktop";
        "image/avif" = "imv.desktop";
        "application/pdf" = "org.gnome.Evince.desktop";
      };
    };
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
    gtk4 = {
      inherit (config.gtk) theme;
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
    };
  };

  # Disable niri-flake's config generation; we use an out-of-store symlink instead
  programs.niri.config = null;

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

  xdg.configFile = {
    "niri" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/impuremonad/nixconfig/dotfiles/niri";
      recursive = true;
    };
  };

  home.file = {
    "Pictures/Wallpapers" = {
      source = ../wallpapers;
      recursive = true;
    };

    ".pi" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/impuremonad/nixconfig/dotfiles/pi";
      recursive = true;
    };
  };

  home.file.".face".source = ../assets/.face;
}
