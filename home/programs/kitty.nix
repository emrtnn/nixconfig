{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    # Oxocarbon is not in the pinned kitty-themes collection.
    extraConfig = ''
      include ${pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/Oxocarbon-Theme/kitty/07b0081fdb1a5acf4a868d70e8305c35aa872e58/oxocarbon_dark.conf";
        hash = "sha256-QXicP0qXlqQTwnQEHYmeQYEhnhUz0e4W9yOEVZ8eddI=";
      }}
    '';
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 14;
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
    settings = {
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
    };
    keybindings = {
      "ctrl+insert" = "copy_to_clipboard";
      "shift+insert" = "paste_from_clipboard";
      # Preserve Shift+Enter through tmux instead of sending plain Return.
      "shift+enter" = "send_text all \\x1b[13;2u";
    };
  };
}
