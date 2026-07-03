{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  home = {
    username = "impuremonad";
    homeDirectory = "/home/impuremonad";
    stateVersion = "26.05";
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
    ../modules/programs/zsh.nix
    ../modules/programs/fzf.nix
    ../modules/desktop/swappy.nix
    ../modules/desktop/noctalia.nix
    ../modules/programs/onlyoffice.nix
    ../modules/programs/jujutsu.nix
    ../modules/programs/nvim.nix
    ../modules/programs/foot.nix
    ../modules/programs/hunk.nix
  ];

  home.packages = with pkgs; [
    bat
    # logseq
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
    qt6Packages.qt6ct
    adw-gtk3
    nwg-look
    ffmpeg
    mpv
    btop
    amp-cli
    wl-clipboard
    wtype
    evince
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
    blender
    herdr
    vesktop
  ];

  xdg = {
    enable = true;

    configFile = {
      "herdr/config.toml".source = ../dotfiles/herdr/config.toml;
    };

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

  home.activation.removeOldHerdrConfigSymlink = lib.hm.dag.entryBefore ["checkLinkTargets"] ''
    herdr_config="${config.xdg.configHome}/herdr"
    if [ -L "$herdr_config" ] && [ "$(readlink "$herdr_config")" = "/home/impuremonad/nixconfig/dotfiles/herdr" ]; then
      rm "$herdr_config"
    fi
  '';

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
