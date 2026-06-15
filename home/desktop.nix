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
    inputs.noctalia.homeModules.default
    inputs.sops-nix.homeManagerModules.sops
    ../modules/programs/carapace.nix
    ../modules/programs/nushell.nix
    ../modules/programs/starship.nix
    ../modules/programs/yazi.nix
    ../modules/programs/zoxide.nix
    ../modules/programs/git.nix
    ../modules/programs/opencode.nix
    ../modules/programs/pi.nix
    ../modules/programs/tmux.nix
    ../modules/programs/zsh.nix
    ../modules/programs/vesktop.nix
    ../modules/programs/fzf.nix
    ../modules/desktop/swappy.nix
    ../modules/desktop/noctalia.nix
    ../modules/programs/onlyoffice.nix
    ../modules/programs/thunderbird.nix
    ../modules/programs/jujutsu.nix
    ../modules/programs/nvim.nix
    ../modules/programs/foot.nix
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
    telegram-desktop
    nautilus
    imv
    grim
    slurp
    gpu-screen-recorder
    hyprpicker
    hyprshot
    grimblast
    brightnessctl
    playerctl
    qt5.qtwayland
    qt6.qtwayland
    ffmpeg
    mpv
    btop
    amp-cli
    wl-clipboard
    wtype
    evince
    (logseq.override {electron_39 = electron_40;})
    gh
    devenv
    uv
    python3
    unzip
    typora
    sops
    age
    (pass.withExtensions (exts: [exts.pass-otp]))
    cachix
    inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.hunk.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

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
        "application/pdf" = "onlyoffice-desktopeditors.desktop";
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
      inherit (config.gtk) theme iconTheme;
      extraConfig = {
        gtk-application-prefer-dark-theme = 1;
      };
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

  home.file.".face.png".source = ../assets/.face;

  sops = {
    defaultSopsFile = ../secrets/secrets.yaml;
    age.keyFile = "/home/impuremonad/.config/sops/age/keys.txt";

    secrets.brave_api_key = {};
  };

  home.sessionVariables = {
    BROWSER = "helium";
    CHROME_PATH = "${pkgs.google-chrome}/bin/google-chrome";
    BRAVE_API_KEY_FILE = "${config.home.homeDirectory}/.config/sops-nix/secrets/brave_api_key";
  };

  systemd.user.sessionVariables = config.home.sessionVariables;
}
