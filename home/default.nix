{
  pkgs,
  inputs,
  ...
}: {
  home.username = "impuremonad";
  home.homeDirectory = "/home/impuremonad";
  home.stateVersion = "25.11";

  imports = [
    inputs.nvf.homeManagerModules.default
    ../modules/desktop
  ];

  home.packages = with pkgs; [
    bat
    fzf
    lazygit
    ripgrep
    fd
    tree
    brave
    google-chrome
    nautilus
    bitwarden-desktop
    (inputs.quickshell.packages.${pkgs.system}.default.withModules (with pkgs.qt6; [
      qtsvg
      qt5compat
      qtimageformats
    ]))
  ];

  home.sessionVariables = {
    SHELL = "${pkgs.nushell}/bin/nu";
    BROWSER = "brave";
  };

  programs.bash = {
    enable = true;
    profileExtra = ''
      if uwsm check may-start; then
        exec uwsm start hyprland-uwsm.desktop
      fi
    '';
  };
  home.file."Pictures/Wallpapers" = {
    source = ../wallpapers;
    recursive = true;
  };
}
