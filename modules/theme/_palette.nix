# Caelus: warm cream on near-black with a saturated orange accent.
# Colors from dacctal's caelus (https://git.symlinx.net/daccfiles: foot.ini and
# nvim lua/caelus); the slightly more saturated greens, role assignments and
# diff tints are local.
# Shared data only: each application module remains independently selectable.
# Hand-written copies (keep in sync): dotfiles/nvim/colors/caelus.lua,
# dotfiles/librewolf/chrome/*.css, mango, niri, hypr, polybar, rofi, tmux.
rec {
  # Surfaces, darkest to lightest (greys carry a slight green tint).
  bg = "#0f0f0f";
  gray0 = "#141514"; # sunken: status/tab bars
  gray1 = "#1e1f1e"; # raised: popups, inputs, cursor line
  gray2 = "#272a28"; # hover, selected rows
  gray3 = "#3b403c"; # selection, borders
  gray4 = "#585f5b"; # inactive borders, line numbers
  gray5 = "#6c756f"; # disabled text
  gray6 = "#888e7b"; # comments, muted text (5.7:1 on bg)
  gray7 = "#9a9c8b"; # secondary text
  gray8 = "#b6b69a"; # operators, punctuation
  gray9 = "#d9cdb5"; # dimmed foreground
  fg = "#f4decd"; # cream foreground (14.8:1 on bg)

  # Accents: normal / light variants of the 16-color terminal palette.
  orange = "#ef934d"; # THE accent: focus, selection, keywords
  orangeLight = "#f4b585";
  yellow = "#efbf71"; # functions, warnings
  red = "#f16e65"; # errors, deletions, urgent
  redLight = "#ef968f";
  green = "#72ca68"; # strings, additions
  greenLight = "#98d694";
  cyan = "#7ec9a3"; # types, hints
  cyanLight = "#abd4bf";
  blue = "#71b4d6"; # modules, info, links
  blueLight = "#b0d4e8"; # fields, properties
  magenta = "#e28dc6"; # numbers, constants
  magentaLight = "#ebadd6";

  # Accent tints over bg (15%), for diff and message backgrounds.
  greenTint = "#1e2b1c";
  redTint = "#311d1c";
  blueTint = "#1e282d";
  orangeTint = "#312318";

  # ANSI order: black red green yellow blue magenta cyan white (+ bright).
  terminal = {
    normal = [bg red green orange blue magenta cyan gray9];
    bright = [gray3 redLight greenLight orangeLight blueLight magentaLight cyanLight fg];
  };
}
