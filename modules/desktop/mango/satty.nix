{config, ...}: let
  c = config.theme.caelus;
in {
  flake.modules.homeManager.mango = {config, ...}: {
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
          c.orange
          c.red
          c.yellow
          c.green
          c.blue
          c.magenta
          c.fg
        ];
      };
    };
  };
}
