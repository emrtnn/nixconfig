{pkgs, ...}: {
  programs.yazi = {
    enable = true;

    flavors = {
      "gruvbox-dark" = pkgs.fetchFromGitHub {
        owner = "bennyyip";
        repo = "gruvbox-dark.yazi";
        rev = "main";
        sha256 = "sha256-Y/i+eS04T2+Sg/Z7/CGbuQHo5jxewXIgORTQm25uQb4=";
      };
    };

    theme = {
      flavor = {
        dark = "gruvbox-dark";
        light = "gruvbox-dark";
      };
    };

    settings = {
      mrg = {linemode = "size";};
    };

    plugins = {
      inherit (pkgs.yaziPlugins) full-border;
    };
  };
}
