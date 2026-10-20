{pkgs, ...}: let
  c = import ../themes/caelus.nix;
  toml = pkgs.formats.toml {};
in {
  home.packages = [pkgs.tuicr];

  xdg.configFile = {
    "tuicr/config.toml".source = ../../dotfiles/tuicr/config.toml;
    "tuicr/themes/caelus.tmTheme".source = import ../themes/caelus-tmtheme.nix {inherit pkgs;};
    "tuicr/themes/caelus.toml".source = toml.generate "tuicr-caelus.toml" {
      panel_bg = c.bg;
      bg_highlight = c.gray2;
      fg_primary = c.fg;
      fg_secondary = c.gray9;
      fg_dim = c.gray6;
      diff_add = c.green;
      diff_add_bg = c.greenTint;
      diff_del = c.red;
      diff_del_bg = c.redTint;
      diff_context = c.gray9;
      diff_hunk_header = c.blue;
      expanded_context_fg = c.gray6;
      syntax_add_bg = c.greenTint;
      syntax_del_bg = c.redTint;
      syntax_theme = "caelus.tmTheme";
      file_added = c.green;
      file_modified = c.yellow;
      file_deleted = c.red;
      file_renamed = c.magenta;
      reviewed = c.green;
      pending = c.yellow;
      comment_note = c.blue;
      comment_suggestion = c.cyan;
      comment_issue = c.red;
      comment_praise = c.green;
      border_focused = c.orange;
      border_unfocused = c.gray3;
      status_bar_bg = c.gray0;
      cursor_color = c.orange;
      cursor_line_bg = c.gray1;
      branch_name = c.orange;
      help_indicator = c.gray6;
      message_info_fg = c.bg;
      message_info_bg = c.blue;
      message_warning_fg = c.bg;
      message_warning_bg = c.yellow;
      message_error_fg = c.bg;
      message_error_bg = c.red;
      update_badge_fg = c.bg;
      update_badge_bg = c.yellow;
      mode_fg = c.bg;
      mode_bg = c.orange;
    };
  };
}
