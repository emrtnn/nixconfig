{
  lib,
  pkgs,
  ...
}: let
  c = import ../themes/caelus.nix;
  # color0..color15 from the shared ANSI palette, as in Foot.
  ansi =
    lib.listToAttrs (lib.imap0 (i: color: lib.nameValuePair "color${toString i}" color)
      (c.terminal.normal ++ c.terminal.bright));
in {
  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 14;
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
    settings =
      {
        shell = "${pkgs.zsh}/bin/zsh";

        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";

        window_padding_width = "2 7";
        hide_window_decorations = "yes";
        show_window_resize_notification = "no";
        confirm_os_window_close = 0;

        allow_remote_control = "no";

        cursor_shape = "block";
        cursor_blink_interval = "0.4";
        shell_integration = "no-cursor";
        cursor_trail = 3;
        cursor_trail_decay = "0.1 0.4";
        cursor_trail_start_threshold = 2;
        enable_audio_bell = "no";
        scrollback_lines = 100000;
        background_opacity = 1;

        tab_bar_edge = "bottom";
        tab_bar_style = "powerline";
        tab_powerline_style = "slanted";
        tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";

        # Caelus colors, generated from home/themes/caelus.nix.
        foreground = c.fg;
        background = c.bg;
        selection_foreground = c.bg;
        selection_background = c.orange;
        cursor = c.orange;
        cursor_text_color = c.bg;
        url_color = c.blue;
        active_border_color = c.orange;
        inactive_border_color = c.gray3;
        bell_border_color = c.red;
        active_tab_foreground = c.bg;
        active_tab_background = c.orange;
        inactive_tab_foreground = c.gray7;
        inactive_tab_background = c.gray1;
        tab_bar_background = c.gray0;
        mark1_foreground = c.bg;
        mark1_background = c.orange;
        mark2_foreground = c.bg;
        mark2_background = c.yellow;
        mark3_foreground = c.bg;
        mark3_background = c.cyan;
      }
      // ansi;
    keybindings = {
      "ctrl+insert" = "copy_to_clipboard";
      "shift+insert" = "paste_from_clipboard";
      # Preserve Shift+Enter through tmux instead of sending plain Return.
      "shift+enter" = "send_text all \\x1b[13;2u";
    };
  };
}
