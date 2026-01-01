{
  config,
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
    fastfetch
    bat
    fzf
    lazygit
    ripgrep
    fd
    tree
    brave
    stow
    bitwarden-desktop
  ];

  home.sessionVariables = {
    SHELL = "${pkgs.nushell}/bin/nu";
    BROWSER = "brave";
  };

  programs.bash = {
    enable = true;
    profileExtra = ''
      if uwsm check may-start; then
        exec uwsm start hyprland.desktop
      fi
    '';
  };
}
