{
  lib,
  pkgs,
  ...
}: let
  c = import ../themes/caelus.nix;
  hex = lib.removePrefix "#";
  # regular0..7 / bright0..7 from the shared ANSI palette.
  ansi = prefix: colors: lib.listToAttrs (lib.imap0 (i: color: lib.nameValuePair "${prefix}${toString i}" (hex color)) colors);
in {
  programs.foot = {
    enable = true;
    package = pkgs.foot.override {
      allowPgo = true;
    };
    server.enable = true;
    settings = {
      main = {
        shell = "${pkgs.zsh}/bin/zsh";
        font = "Iosevka Nerd Font Mono:size=16";
        pad = "7x2";
        dpi-aware = true;
      };

      cursor = {
        style = "block";
        blink = true;
      };

      # Caelus colors, generated from home/themes/caelus.nix (same as Kitty).
      colors-dark =
        {
          alpha = 1;
          blur = false;
          foreground = hex c.fg;
          background = hex c.bg;
          selection-foreground = hex c.bg;
          selection-background = hex c.orange;
          cursor = "${hex c.bg} ${hex c.orange}";
          urls = hex c.blue;
          search-box-no-match = "${hex c.bg} ${hex c.red}";
          search-box-match = "${hex c.bg} ${hex c.orange}";
        }
        // ansi "regular" c.terminal.normal
        // ansi "bright" c.terminal.bright;

      mouse = {
        hide-when-typing = "yes";
      };

      scrollback.lines = 100000;
    };
  };
}
