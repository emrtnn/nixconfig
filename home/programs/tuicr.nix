{pkgs, ...}: let
  c = import ../themes/oxocarbon.nix;
  toml = pkgs.formats.toml {};
in {
  home.packages = [pkgs.tuicr];

  xdg.configFile = {
    "tuicr/config.toml".source = ../../dotfiles/tuicr/config.toml;
    "tuicr/themes/oxocarbon-dark.tmTheme".source = import ../themes/oxocarbon-tmtheme.nix {inherit pkgs;};
    "tuicr/themes/oxocarbon-dark.toml".source = toml.generate "tuicr-oxocarbon-dark.toml" {
      panel_bg = c.base00;
      bg_highlight = c.base02;
      fg_primary = c.base05;
      fg_secondary = c.base04;
      fg_dim = c.muted;
      diff_add = c.base0D;
      # Carbon Green 90 / Magenta 90 keep diff backgrounds dark and distinct.
      diff_add_bg = "#022d0d";
      diff_del = c.base0A;
      diff_del_bg = "#510224";
      diff_context = c.base04;
      diff_hunk_header = c.base09;
      expanded_context_fg = c.muted;
      syntax_add_bg = "#022d0d";
      syntax_del_bg = "#510224";
      syntax_theme = "oxocarbon-dark.tmTheme";
      file_added = c.base0D;
      file_modified = c.base0F;
      file_deleted = c.base0A;
      file_renamed = c.base0E;
      reviewed = c.base0D;
      pending = c.base0F;
      comment_note = c.base09;
      comment_suggestion = c.base08;
      comment_issue = c.base0A;
      comment_praise = c.base0D;
      border_focused = c.base09;
      border_unfocused = c.base03;
      status_bar_bg = c.base01;
      cursor_color = c.base0C;
      cursor_line_bg = c.base01;
      branch_name = c.base0E;
      help_indicator = c.muted;
      message_info_fg = c.base00;
      message_info_bg = c.base09;
      message_warning_fg = c.base00;
      message_warning_bg = c.base0F;
      message_error_fg = c.base00;
      message_error_bg = c.base0A;
      update_badge_fg = c.base00;
      update_badge_bg = c.base0F;
      mode_fg = c.base00;
      mode_bg = c.base08;
    };
  };
}
