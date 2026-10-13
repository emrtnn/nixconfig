{config, ...}: {
  programs = {
    git = {
      enable = true;

      signing = {
        format = "ssh";
        key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        signByDefault = true;
        allowedSigners = ''
          emrtnn@proton.me ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINq9LHmDASE2/Wn0/cqtS4HNOB5m4r26QeD7pgZiX8di arpano
          emrtnn@proton.me ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFnuJ+p8b8WEZEMKFr/399lyyTqU2xJIEuljT+fBMyJy monad
        '';
      };

      settings = {
        fetch = {
          prune = true;
        };
        pull = {
          rebase = true;
        };
        rebase = {
          autoSquash = true;
          autoStash = true;
          updateRefs = true;
        };
        merge = {
          conflictstyle = "zdiff3";
        };
        push = {
          default = "simple";
        };
        commit = {
          verbose = true;
          gpgSign = true;
        };
        core = {
          editor = "nvim";
          autocrlf = "input";
        };
        color = {
          ui = "auto";
        };
        diff = {
          colorMoved = "default";
          algorithm = "histogram";
        };
        branch = {
          sort = "-committerdate";
        };
        init = {
          defaultBranch = "master";
        };
        log = {
          date = "relative";
        };
        rerere = {
          enabled = true;
          autoUpdate = true;
        };
        alias = {
          fpush = "push --force-with-lease --force-if-includes";
          plog = "log --graph --pretty=format:'%C(yellow)%h (%Creset%Cgreen%p%Creset%C(yellow))%Creset -%Cred%d%Creset %s %Cgreen(%cr)%Creset %C(bold blue)<%an>%Creset' --abbrev-commit --all";
        };
      };
    };
  };
}
