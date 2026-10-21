{
  flake.modules.homeManager.workstation = {pkgs, ...}: {
    home.packages = with pkgs; [
      mpv
      vesktop
    ];
  };
}
