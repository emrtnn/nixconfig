{config, ...}: {
  programs.jujutsu = {
    enable = true;

    settings = {
      aliases = {
        logver = ["log" "--config" "ui.show-cryptographic-signatures=true"];
      };

      ui = {
        color = "always";
        editor = "nvim";
        default-revset = "all()";
        diff-formatter = ":git";
        paginate = "auto";
      };

      merge = {
        conflict-marker-style = "diff3";
      };

      git = {
        default-branch = "master";
        colocate = true;
      };

      # Same SSH key and allowed signers as Git (home/programs/git.nix).
      signing = {
        backend = "ssh";
        behavior = "own";
        inherit (config.programs.git.signing) key;
        backends.ssh.allowed-signers = "${config.xdg.configHome}/git/allowed_signers";
      };
    };
  };
}
