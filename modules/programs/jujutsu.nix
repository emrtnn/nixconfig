{...}: {
  programs.jujutsu = {
    enable = true;
    settings = {
      user = {
        name = "emrtnn";
        email = "enriquemartin1402@gmail.com";
      };
      ui = {
        color = "always";
        editor = "nvim";
        default-revset = "::";
      };
      merge = {
        conflict-marker-style = "diff3";
      };
      git = {
        default-branch = "master";
      };
    };
  };
}
