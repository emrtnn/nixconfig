_: {
  programs.jujutsu = {
    enable = true;

    settings = {
      user = {
        name = "emrtnn";
        email = "emrtnn@proton.me";
      };

      aliases = {
        logver = ["log" "--config" "ui.show-cryptographic-signatures=true"];
      };

      signing = {
        backend = "gpg";
        key = "emrtnn@proton.me";
        sign-all = true;
        behavior = "own";
      };

      ui = {
        color = "always";
        editor = "nvim";
        default-revset = "all()";
        diff-formatter = ":git";
      };

      merge = {
        conflict-marker-style = "diff3";
      };

      git = {
        default-branch = "master";
        colocate = true;
      };
    };
  };
}
