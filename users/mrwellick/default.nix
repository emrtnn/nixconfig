{ pkgs, config-files, ... }:
{

  home.username = "mrwellick";
  home.homeDirectory = "/home/mrwellick";
  home.stateVersion = "25.05";

  imports = [
    ../../modules/home-manager/programs/git.nix
    ../../modules/home-manager/programs/nushell.nix
    ../../modules/home-manager/programs/jujutsu.nix
    ../../modules/home-manager/programs/ghostty.nix
    ../../modules/home-manager/programs/starship.nix
    ../../modules/home-manager/programs/helix.nix
    ../../modules/home-manager/programs/yazi.nix
    ../../modules/home-manager/programs/fastfetch.nix
    ../../modules/home-manager/programs/mtp.nix
    ../../modules/home-manager/programs/github-cli.nix
    ../../modules/home-manager/programs/direnv.nix
    ../../modules/home-manager/programs/walker.nix
    ../../modules/home-manager/programs/lsp.nix
  ];

  home.packages = with pkgs; [
    cachix
    nautilus
    brave
    eza
    ripgrep
    fzf
    btop
    libnotify
    wl-clipboard
    hyprpicker
    hyprshot
    playerctl
    telegram-desktop
    hyperfine
    flamegraph
    zip
    unzip
    calibre
    mdbook
    keepass
    postgresql
    dbeaver-bin
    hypridle
    hyprlock
    gparted
    tree
    evince
    localsend
    ripgrep
    libreoffice
    claude-code
    smile
    neovim
  ];

  xdg.enable = true;
  xdg.userDirs.enable = true;

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.gnome.Evince.desktop";
    };
  };

  home.sessionVariables = {
    SHELL = "${pkgs.nushell}/bin/nu";
    BROWSER = "brave";
  };

  services.swww.enable = true;

  services.swaync = {
    enable = true;
  };

  services.clipse = {
    enable = true;
    allowDuplicates = false;
  };

  programs.vesktop = {
    enable = true;
  };

  xdg.configFile = {
    # Hyprland
    "hypr/hyprland.conf".source = config-files.hyprland.config;

    # Hyprlock
    "hypr/hyprlock.conf".source = config-files.hyprlock.config;

    # Hypridle
    "hypr/hypridle.conf".source = config-files.hypridle.config;

    # Waybar
    "waybar/config".source = config-files.waybar.config;
    "waybar/style.css".source = config-files.waybar.styleCss;
    "waybar/kanagawa.css".source = config-files.waybar.kanagawaCss;

    # Btop
    "btop/btop.conf".source = config-files.btop.config;
    "btop/themes/btop.theme".source = config-files.btop.theme;

    # Yazi
    "yazi/theme.toml".source = config-files.yazi.theme;

    # Neovim
    "nvim/".source = config-files.nvim;
  };

  home.file = {
    # Wallpapers
    ".wallpapers/mountain_wp.jpeg" = {
      source = config-files.wallpapers.mountain;
    };

    # Cursor styles
    ".local/share/icons/BreezeX-Black-hyprcursor" = {
      source = config-files.cursors.breezeBlack;
    };
  };
}
