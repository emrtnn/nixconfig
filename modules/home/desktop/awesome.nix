{
  config,
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
in {
  imports = [../programs/kitty.nix];

  xsession = {
    enable = true;
    windowManager.awesome.enable = true;
    profileExtra = ''
      export XDG_CURRENT_DESKTOP=awesome
      ${pkgs.dbus}/bin/dbus-update-activation-environment --systemd DISPLAY XAUTHORITY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE XDG_SESSION_ID
    '';
    initExtra = ''
      ${pkgs.xset}/bin/xset r rate 600 25
      ${pkgs.numlockx}/bin/numlockx off
      ${pkgs.xset}/bin/xset +dpms
      ${pkgs.xset}/bin/xset dpms 0 0 660
    '';
  };

  home.sessionVariables.QT_QPA_PLATFORMTHEME = "qt6ct";
  programs.kitty.settings.linux_display_server = "x11";

  xdg.configFile = {
    "awesome/rc.lua".source = ../../../dotfiles/awesome/rc.lua;
    "awesome/bindings.lua".source = ../../../dotfiles/awesome/bindings.lua;
    "awesome/theme.lua".source = ../../../dotfiles/awesome/theme.lua;
  };

  programs.rofi = {
    enable = true;
    settings = {
      terminal = "kitty";
      font = "GeistMono Nerd Font Mono 12";
      "show-icons" = true;
    };
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        background-color = mkLiteral "#282828";
        text-color = mkLiteral "#ebdbb2";
      };
      window = {
        width = mkLiteral "640px";
        border = mkLiteral "3px";
        border-color = mkLiteral "#d79921";
        padding = mkLiteral "12px";
      };
      inputbar = {
        padding = mkLiteral "8px";
        spacing = mkLiteral "8px";
        children = map mkLiteral ["prompt" "entry"];
      };
      listview = {
        lines = 8;
        spacing = mkLiteral "4px";
        scrollbar = false;
      };
      element.padding = mkLiteral "7px";
      "element selected.normal" = {
        background-color = mkLiteral "#d79921";
        text-color = mkLiteral "#201b14";
      };
    };
  };

  services = {
    copyq = {
      enable = true;
      # Nonempty settings would start the GUI during headless HM activation.
      settings = {};
    };
    picom = {
      enable = true;
      backend = "xrender";
      activeOpacity = 1.0;
      inactiveOpacity = 0.95;
      shadow = true;
      shadowOffsets = [2 2];
      settings = {
        shadow-color = "#000000";
        shadow-radius = 12;
      };
    };
    network-manager-applet.enable = true;
    polkit-gnome.enable = true;
    screen-locker = {
      enable = true;
      inactiveInterval = 10;
      xautolock.enable = false;
      xss-lock.extraOptions = ["--transfer-sleep-lock"];
      lockCmd = "${pkgs.i3lock}/bin/i3lock --nofork -c 201b14";
    };
  };

  home.packages = [
    screenshot
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
  ];
}
