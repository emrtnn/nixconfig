{
  pkgs,
  config,
  ...
}: {
  programs.swappy = {
    enable = true;

    settings = {
      Default = {
        save_dir = "${config.home.homeDirectory}/Pictures/Screenshots";
        save_filename_format = "swappy-%Y%m%d-%H%M%S.png";
        early_exit = true;
        show_panel = false;
        line_size = 5;
        text_size = 20;
        text_font = "sans-serif";
        paint_mode = "brush";
      };
    };
  };
}
