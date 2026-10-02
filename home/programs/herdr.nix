{
  lib,
  pkgs,
  ...
}: let
  c = import ../themes/oxocarbon.nix;
  toml = pkgs.formats.toml {};
  preferences = builtins.fromTOML (builtins.readFile ../../dotfiles/herdr/config.toml);
in {
  home.packages = with pkgs; [
    herdr
  ];

  xdg.configFile."herdr/config.toml".source = toml.generate "herdr-config.toml" (lib.recursiveUpdate preferences {
    # Herdr has no Oxocarbon preset; override every token over its terminal base.
    theme = {
      name = "terminal";
      custom = {
        accent = c.base09;
        panel_bg = c.base00;
        sidebar_bg = c.base01;
        active_row_bg = c.base02;
        selection_bg = c.base02;
        surface0 = c.base01;
        surface1 = c.base02;
        surface_dim = c.base00;
        overlay0 = c.base03;
        overlay1 = c.muted;
        text = c.base05;
        subtext0 = c.base04;
        mauve = c.base0E;
        green = c.base0D;
        yellow = c.base0F;
        red = c.base0A;
        blue = c.base0B;
        teal = c.base08;
        peach = c.base0C;
      };
    };
  });
}
