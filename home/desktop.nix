{
  pkgs,
  inputs,
  config,
  ...
}: {
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
    ../modules/programs/fzf.nix
    ../modules/desktop/swappy.nix
    ../modules/desktop/hyprlock.nix
    ../modules/desktop/hypridle.nix
    ../modules/desktop/noctalia.nix
    ../modules/programs/thunderbird.nix
  ];

  home.packages = with pkgs; [
    bat
    lazygit
    ripgrep
    fd
    dnsutils
    tree
    tree-sitter
    brave
    google-chrome
    nautilus
    bitwarden-desktop
    grim
    slurp
    hyprpicker
    wf-recorder
    ffmpeg
    mpv
    btop
    amp-cli
    wl-clipboard
    hyprpaper
  ];

  home.sessionVariables = {
    SHELL = "${pkgs.zsh}/bin/zsh";
    BROWSER = "brave";
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

  xdg.configFile = {
    "hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/impuremonad/nixconfig/dotfiles/hypr";
      recursive = true;
    };
    "quickshell" = {
      source = config.lib.file.mkOutOfStoreSymlink "/home/impuremonad/nixconfig/dotfiles/quickshell";
      recursive = true;
    };
  };

  home.file."Pictures/Wallpapers" = {
    source = ../wallpapers;
    recursive = true;
  };

  home.file.".face".source = ../assets/.face;
}
