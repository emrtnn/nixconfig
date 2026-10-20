{
  flake.modules.nixos.base = {pkgs, ...}: {
    users.users.impuremonad = {
      isNormalUser = true;
      description = "impuremonad";
      shell = pkgs.zsh;
      extraGroups = ["networkmanager" "wheel" "video" "render"];
    };

    home-manager.users.impuremonad = {};
  };

  flake.modules.homeManager.base = {
    home = {
      username = "impuremonad";
      homeDirectory = "/home/impuremonad";
      file.".face.png".source = ../../assets/.face;
    };

    programs = {
      git.settings.user = {
        name = "emrtnn";
        email = "emrtnn@proton.me";
      };
      jujutsu.settings.user = {
        name = "emrtnn";
        email = "emrtnn@proton.me";
      };
    };
  };
}
