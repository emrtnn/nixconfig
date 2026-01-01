{pkgs, ...}: {
  programs.yazi = {
    enable = true;

    flavors = {
      "gruvbox-dark" = pkgs.fetchFromGitHub {
        owner = "bennyyip";
        repo = "gruvbox-dark.yazi";
        rev = "main";
        sha256 = "sha256-qNxauqv8tRPztO17PGKl3ue6cSWGqIuEzYViaRXDVcQ=";
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
