{config, ...}: let
  c = import ../themes/oxocarbon.nix;
in {
  programs.satty = {
    enable = true;

    settings = {
      general = {
        output-filename = "${config.home.homeDirectory}/Pictures/Screenshots/satty-%Y%m%d-%H%M%S.png";
        early-exit = true;
        initial-tool = "brush";
        copy-command = "wl-copy";
        actions-on-enter = ["save-to-clipboard"];
        actions-on-escape = ["exit"];
        annotation-size-factor = 1;
        corner-roundness = 8;
        brush-smooth-history-size = 5;
        no-window-decoration = true;
      };

      font = {
        family = "sans-serif";
        style = "Regular";
      };

      color-palette.palette = map (hex: "${hex}ff") [
        c.base0A # red
        c.base0C # pink
        c.base09 # blue
        c.base08 # cyan
        c.base0D # green
        c.base0E # purple
        c.base05 # white
      ];
    };
  };
}
