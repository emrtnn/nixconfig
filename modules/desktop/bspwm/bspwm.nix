{config, ...}: let
  c = config.theme.caelus;
in {
  flake.modules.nixos.bspwm = {pkgs, ...}: {
    services.xserver = {
      enable = true;
      windowManager.bspwm.enable = true;
      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };

    services.displayManager.defaultSession = "none+bspwm";

    security.polkit.enable = true;
    programs.i3lock.enable = true;

    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.xdg-desktop-portal-gtk];
      config.common = {
        default = ["gtk"];
        "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
      };
      xdgOpenUsePortal = true;
    };
  };

  flake.modules.homeManager.bspwm = {
    lib,
    pkgs,
    ...
  }: let
    screenshot = pkgs.writeShellApplication {
      name = "nixconfig-screenshot";
      runtimeInputs = [pkgs.coreutils pkgs.scrot pkgs.xclip pkgs.ksnip pkgs.xset];
      text = ''
        usage() {
          printf 'Usage: nixconfig-screenshot region-edit|full-edit|region-copy|full-save\n' >&2
        }
        if [[ $# -ne 1 ]]; then usage; exit 2; fi
        case "$1" in
          region-edit|full-edit|region-copy|full-save) ;;
          *) usage; exit 2 ;;
        esac

        if [[ -z "''${DISPLAY:-}" ]] || ! xset q >/dev/null 2>&1; then
          printf 'DISPLAY must identify an accessible X session.\n' >&2
          exit 1
        fi
        if [[ -z "''${XDG_RUNTIME_DIR:-}" || ! -d "$XDG_RUNTIME_DIR" || -L "$XDG_RUNTIME_DIR" || ! -O "$XDG_RUNTIME_DIR" ]]; then
          printf 'XDG_RUNTIME_DIR must be an owned, real directory.\n' >&2
          exit 1
        fi
        if [[ "$(stat -Lc '%a' -- "$XDG_RUNTIME_DIR")" != 700 ]]; then
          printf 'XDG_RUNTIME_DIR must have mode 0700.\n' >&2
          exit 1
        fi
        umask 077

        if [[ "$1" == full-save ]]; then
          if [[ -z "''${HOME:-}" || "$HOME" != /* ]]; then
            printf 'HOME must be an absolute path.\n' >&2
            exit 1
          fi
          mkdir -p -- "$HOME/Pictures/Screenshots"
          file="$HOME/Pictures/Screenshots/$(date '+%Y-%m-%d_%H-%M-%S-%N').png"
          [[ ! -e "$file" ]]
          scrot "$file"
          [[ -s "$file" ]]
          exit 0
        fi

        capture_root="$XDG_RUNTIME_DIR/nixconfig-capture"
        if [[ -L "$capture_root" || ( -e "$capture_root" && ( ! -d "$capture_root" || ! -O "$capture_root" ) ) ]]; then
          printf 'Unsafe screenshot runtime directory.\n' >&2
          exit 1
        fi
        mkdir -p -- "$capture_root"
        chmod 0700 -- "$capture_root"
        directory="$(mktemp -d "$capture_root/capture.XXXXXXXXXX")"
        file="$directory/capture.png"
        args=()
        if [[ "$1" == region-* ]]; then args+=(--select); fi
        if scrot "''${args[@]}" "$file"; then
          if [[ ! -s "$file" ]]; then
            printf 'Capture produced no image.\n' >&2
            rm -rf -- "$directory"
            exit 1
          fi
        else
          status=$?
          printf 'Capture failed or was cancelled (exit %s).\n' "$status" >&2
          rm -rf -- "$directory"
          exit "$status"
        fi
        xclip -selection clipboard -t image/png -i < "$file"
        # Keep the input for the runtime-directory lifetime: Ksnip can reuse an
        # existing editor process and return before it has finished opening it.
        if [[ "$1" == *-edit ]]; then exec ksnip --edit "$file"; fi
      '';
    };
    target = pkgs.writeShellApplication {
      name = "argos-target";
      runtimeInputs = [pkgs.python3 pkgs.rofi pkgs.xclip];
      text = ''exec ${pkgs.python3}/bin/python3 ${./dotfiles/argos/target.py} "$@"'';
    };
    network = pkgs.writeShellApplication {
      name = "argos-network";
      runtimeInputs = [pkgs.python3 pkgs.curl pkgs.iproute2 pkgs.xclip];
      text = ''exec ${pkgs.python3}/bin/python3 ${./dotfiles/argos/network.py} "$@"'';
    };
    menu = pkgs.writeShellApplication {
      name = "argos-menu";
      runtimeInputs = [pkgs.rofi pkgs.bspwm pkgs.systemd pkgs.pavucontrol pkgs.networkmanagerapplet pkgs.arandr pkgs.keepassxc target];
      text = builtins.readFile ./dotfiles/argos/menu.sh;
    };
    polybarLauncher = pkgs.writeShellApplication {
      name = "argos-polybar";
      runtimeInputs = [pkgs.python3 pkgs.polybar pkgs.bspwm pkgs.xrandr pkgs.feh network target menu];
      text = ''exec ${pkgs.python3}/bin/python3 ${./dotfiles/argos/polybar.py} "$@"'';
    };
  in {
    xsession = {
      enable = true;
      windowManager.bspwm = {
        enable = true;
        alwaysResetDesktops = false;
        monitors.primary = ["1" "2" "3" "4" "5" "6" "7" "8" "9"];
        settings = {
          automatic_scheme = "longest_side";
          split_ratio = 0.5;
          window_gap = 8;
          border_width = 3;
          normal_border_color = c.gray3;
          focused_border_color = c.orange;
          focus_follows_pointer = true;
          borderless_monocle = true;
          top_padding = 8;
          bottom_padding = 8;
          left_padding = 8;
          right_padding = 8;
          pointer_modifier = "mod4";
          pointer_action1 = "move";
          pointer_action2 = "none";
          pointer_action3 = "resize_corner";
        };
        rules = {
          Ksnip = {
            state = "floating";
            center = true;
          };
          ksnip = {
            state = "floating";
            center = true;
          };
        };
        extraConfig = builtins.readFile ./dotfiles/bspwm/bspwmrc;
        startupPrograms = [];
      };
      profileExtra = ''
        export XDG_CURRENT_DESKTOP=bspwm
        export XDG_SESSION_TYPE=x11
        export SXHKD_SHELL=${pkgs.bash}/bin/bash
        ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_ID
      '';
      initExtra = ''
        ${pkgs.xset}/bin/xset r rate 600 25
        ${pkgs.numlockx}/bin/numlockx off
        ${pkgs.xset}/bin/xset +dpms
        ${pkgs.xset}/bin/xset dpms 0 0 660
      '';
    };

    programs.kitty.settings.linux_display_server = "x11";

    programs.rofi = {
      enable = true;
      theme = ./dotfiles/rofi/argos.rasi;
      settings = {
        terminal = "kitty";
        font = "GeistMono Nerd Font Mono 10";
        "show-icons" = true;
        "case-sensitive" = false;
      };
    };
    services = {
      sxhkd = {
        enable = true;
        extraConfig = builtins.readFile ./dotfiles/sxhkd/sxhkdrc;
      };
      polybar = {
        enable = true;
        config = ./dotfiles/polybar/config.ini;
        script = "exec ${polybarLauncher}/bin/argos-polybar";
      };
      copyq = {
        enable = true;
        # Nonempty settings would start the GUI during headless HM activation.
        settings = {};
      };
      picom = {
        enable = true;
        backend = "xrender";
        activeOpacity = 1.0;
        inactiveOpacity = 0.98;
        shadow = true;
        shadowOffsets = [2 2];
        shadowExclude = ["class_g = 'Polybar'" "window_type = 'dock'" "window_type = 'desktop'"];
        settings = {
          shadow-color = "#000000";
          shadow-radius = 14;
          corner-radius = 8;
          rounded-corners-exclude = [
            "window_type = 'dock'"
            "window_type = 'desktop'"
            "class_g = 'Rofi'"
            "_NET_WM_STATE@:32a *= '_NET_WM_STATE_FULLSCREEN'"
          ];
        };
      };
      dunst = {
        enable = true;
        settings = {
          global = {
            font = "GeistMono Nerd Font Mono 10";
            frame_color = c.orange;
            foreground = c.fg;
            background = c.bg;
            corner_radius = 10;
            origin = "top-right";
            offset = "12x52";
          };
          urgency_critical = {
            background = c.red;
            foreground = c.bg;
            frame_color = c.red;
          };
        };
      };
      polkit-gnome.enable = true;
      screen-locker = {
        enable = true;
        inactiveInterval = 10;
        xautolock.enable = false;
        xss-lock.extraOptions = ["--transfer-sleep-lock"];
        lockCmd = "${pkgs.i3lock}/bin/i3lock --nofork -c ${lib.removePrefix "#" c.bg}";
      };
    };
    # VMware compares PRIMARY/CLIPBOARD timestamps; Herdr's xclip writer does
    # not provide one. CopyQ owns the synchronized PRIMARY with a valid timestamp.
    # Configure only after the GUI service starts, not during HM activation.
    systemd.user.services.copyq.Service.ExecStartPost = "${pkgs.copyq}/bin/copyq config copy_clipboard true";

    systemd.user.services.polybar = {
      Unit.PartOf = lib.mkForce ["graphical-session.target"];
      Service = {
        Type = lib.mkForce "simple";
        KillMode = "control-group";
      };
      Install.WantedBy = lib.mkForce [];
    };

    home.packages = [
      screenshot
      target
      network
      menu
      polybarLauncher
      pkgs.scrot
      pkgs.ksnip
      pkgs.xclip
      pkgs.xdotool
      pkgs.xset
      pkgs.numlockx
      pkgs.arandr
      pkgs.pavucontrol
      pkgs.networkmanagerapplet
      pkgs.wireplumber
      pkgs.feh
    ];
  };
}
