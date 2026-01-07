{
  inputs,
  pkgs,
  ...
}: {
  programs.kitty = {
    enable = true;
    themeFile = "gruvbox-dark";
    font = {
      name = "JetBrainsMono Nerd Font Mono";
      size = 13;
      package = pkgs.nerd-fonts.jetbrains-mono;
    };
    settings = {
      shell = "${pkgs.zsh}/bin/zsh";

      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";

      window_padding_width = 7;
      window_padding_height = 4;
      hide_window_decorations = "yes";
      show_window_resize_notification = "no";
      confirm_os_window_close = 0;

      allow_remote_control = "yes";

      cursor_shape = "block";
      enable_audio_bell = "no";

      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      tab_title_template = "{title}{' :{}:'.format(num_windows) if num_windows > 1 else ''}";
    };
    keybindings = {
      "ctrl+insert" = "copy_from_clipboard";
      "shift+insert" = "paste_from_clipboard";
    };
  };
}
