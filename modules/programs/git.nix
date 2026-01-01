{pkgs, ...}: {
  programs.git = {
    enable = true;

    settings = {
      user = {
        name = "impuremonad";
        email = "enriquemartin1402@gmail.com";
      };
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
        tool = "vimdiff";
      };
      merge = {
        tool = "vimdiff";
        conflictstyle = "zdiff3";
      };

      mergetool = {
        vimdiff = {
          cmd = "nvim -d $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'";
        };
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
      pager = {
        log = "less -F -X -R";
      };
    };
  };
}
