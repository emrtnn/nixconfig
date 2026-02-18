{...}: {
  programs = {
    delta = {
      enable = true;
      options = {
        navigate = true;
        side-by-side = true;
        line-numbers = true;
        syntax-theme = "gruvbox-dark";
        dark = true;
      };
    };

    git = {
      enable = true;

      settings = {
        user = {
          name = "impuremonad";
          email = "enriquemartin1402@gmail.com";
        };
        core = {
          editor = "hx";
          autocrlf = "input";
          pager = "delta";
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
