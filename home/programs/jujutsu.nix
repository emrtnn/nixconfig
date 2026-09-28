_: {
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
    };
  };
}
