{
  lib,
  pkgs,
  ...
}: let
  c = import ../themes/caelus.nix;
  toml = pkgs.formats.toml {};
  preferences = builtins.fromTOML (builtins.readFile ../../dotfiles/herdr/config.toml);
in {
  home.packages = with pkgs; [
    herdr
  ];

  xdg.configFile."herdr/config.toml".source = toml.generate "herdr-config.toml" (lib.recursiveUpdate preferences {
    # Herdr has no Caelus preset; override every token over its terminal base.
    theme = {
      name = "terminal";
      custom = {
        accent = c.orange;
        panel_bg = c.bg;
        sidebar_bg = c.gray0;
        active_row_bg = c.gray2;
        selection_bg = c.gray3;
        surface0 = c.gray1;
        surface1 = c.gray2;
        surface_dim = c.bg;
        overlay0 = c.gray4;
        overlay1 = c.gray6;
        text = c.fg;
        subtext0 = c.gray9;
        mauve = c.magenta;
        green = c.green;
        yellow = c.yellow;
        red = c.red;
        blue = c.blue;
        teal = c.cyan;
        peach = c.orangeLight;
      };
    };
  });
}
