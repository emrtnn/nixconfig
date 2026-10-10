{config, ...}: {
  programs = {
    git = {
      enable = true;

      # Every commit is signed with the host's SSH key (served by gcr-ssh-agent).
      signing = {
        format = "ssh";
        key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        signByDefault = true;
        # Keys trusted when verifying signatures locally; add each host's key here.
        # Written to ~/.config/git/allowed_signers, which jj reads too.
        allowedSigners = ''
          emrtnn@proton.me ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINq9LHmDASE2/Wn0/cqtS4HNOB5m4r26QeD7pgZiX8di arpano
          emrtnn@proton.me ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFnuJ+p8b8WEZEMKFr/399lyyTqU2xJIEuljT+fBMyJy monad
        '';
      };

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
