{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";

    flavors.gruvbox-dark = pkgs.fetchFromGitHub {
      owner = "bennyyip";
      repo = "gruvbox-dark.yazi";
      rev = "619fdc5844db0c04f6115a62cf218e707de2821e";
      hash = "sha256-Y/i+eS04T2+Sg/Z7/CGbuQHo5jxewXIgORTQm25uQb4=";
    };

    theme.flavor = {
      dark = "gruvbox-dark";
      light = "gruvbox-dark";
    };

    settings = {
      mrg = {linemode = "size";};
    };

    plugins = {
      inherit (pkgs.yaziPlugins) full-border;
    };
  };
}
