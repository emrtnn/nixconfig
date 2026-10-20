{
  flake.modules.homeManager.desktop = _: {
    home.file."Pictures/Wallpapers" = {
      source = ../../wallpapers;
      recursive = true;
    };
  };
}
