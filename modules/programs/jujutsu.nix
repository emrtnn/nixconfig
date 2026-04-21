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
      };
    };
  };
}
