_: {
  programs = {
    git = {
      enable = true;

      settings = {
        user = {
          name = "emrtnn";
          email = "emrtnn@proton.me";
        };
        core = {
          editor = "nvim";
          autocrlf = "input";
          pager = "hunk pager";
        };
        color = {
          ui = "auto";
        };
        pull = {
          rebase = true;
        };
        push = {
          default = "simple";
        };
        diff = {
          colorMoved = "default";
        };
        merge = {
          conflictstyle = "zdiff3";
        };
        init = {
          defaultBranch = "master";
        };
        log = {
          date = "relative";
        };
        rerere = {
          enabled = true;
        };
      };
    };
  };
}
