{
  flake.modules.homeManager.workstation = {pkgs, ...}: {
    home.packages = with pkgs; [
      obsidian
      mpv
      vesktop
    ];
  };
}
