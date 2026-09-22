_: {
  programs = {
    git = {
      enable = true;

      settings = {
        core = {
          editor = "nvim";
          autocrlf = "input";
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
