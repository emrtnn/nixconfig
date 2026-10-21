{
  flake.modules.homeManager.workstation = {pkgs, ...}: {
    programs.mpv = {
      enable = true;
      scripts = with pkgs.mpvScripts; [
        modernz
      ];
      config = {
        # ModernZ replaces the built-in OSC
        osc = "no";
      };
    };

    home.packages = with pkgs; [
      vesktop
    ];
  };
}
