{config, pkgs, ...}: {
  imports = [
    ../../home/development.nix
    ../../home/programs/helium.nix
    ../../home/programs/imv.nix
    ../../home/desktop/appearance.nix
    ../../home/desktop/wallpapers.nix
    ../../home/programs/hacking.nix
    ../../home/programs/pi.nix
    ../../home/programs/oh-my-pi.nix
    ../../home/programs/herdr.nix
    ../../home/security/sops.nix
    ../../home/security/password-store.nix
    ../../home/desktop/keyring.nix
    ../../home/programs/onlyoffice.nix
    ../../home/desktop/mango.nix
  ];

  home = {
    username = "impuremonad";
    homeDirectory = "/home/impuremonad";
    stateVersion = "26.05";
    packages = with pkgs; [
      nautilus
      evince
      ffmpeg
      playerctl
      proton-vpn
      tor-browser
      obsidian
      firefox
      telegram-desktop
      mpv
      vesktop
      stremio-linux-shell
    ];
    file.".face.png".source = ../../assets/.face;
    sessionVariables = {
      BRAVE_API_KEY_FILE = "${config.home.homeDirectory}/.config/sops-nix/secrets/brave_api_key";
    };
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/home/impuremonad/.config/sops/age/keys.txt";
    secrets.brave_api_key = {};
  };

  programs.git.settings.user = {
    name = "emrtnn";
    email = "emrtnn@proton.me";
  };
  programs.jujutsu.settings = {
    user = {
      name = "emrtnn";
      email = "emrtnn@proton.me";
    };
    signing = {
      backend = "gpg";
      key = "197CB7FC535093C4";
      sign-all = true;
      behavior = "own";
    };
  };

  programs.noctalia.settings = {
    location = {
      address = "Granada, Spain";
      auto_locate = false;
      custom_schedule = false;
      sunrise = "";
      sunset = "";
    };
    lockscreen_widgets = {
      enabled = true;
      schema_version = 2;
      widget_order = ["lockscreen-login-box@DP-1" "lockscreen-widget-0000000000000001"];
      grid = {
        cell_size = 16;
        major_interval = 4;
        visible = true;
      };
      widget = {
        "lockscreen-login-box@DP-1" = {
          box_height = 70.0;
          box_width = 400.0;
          cx = 1280.0;
          cy = 1317.0;
          enabled = true;
          output = "DP-1";
          rotation = 0.0;
          type = "login_box";
          settings = {
            center_password_text = false;
            show_caps_lock = true;
            show_keyboard_layout = true;
            show_login_button = true;
          };
        };
        "lockscreen-widget-0000000000000001" = {
          box_height = 192.0;
          box_width = 496.0;
          cx = 1280.0;
          cy = 704.0;
          enabled = true;
          output = "DP-1";
          rotation = 0.0;
          type = "clock";
          settings = {};
        };
      };
    };
    plugins.source = [
      {
        enabled = true;
        kind = "git";
        location = "https://github.com/noctalia-dev/official-plugins";
        name = "official";
      }
      {
        enabled = true;
        kind = "git";
        location = "https://github.com/noctalia-dev/community-plugins";
        name = "community";
      }
      {
        enabled = false;
        kind = "path";
        location = "~/Dev/community-plugins";
        name = "local-community-plugins";
      }
    ];
    shell.avatar_path = "/home/impuremonad/Pictures/avatar.png";
    wallpaper.directory = "/home/impuremonad/Pictures/Wallpapers";
  };
}
