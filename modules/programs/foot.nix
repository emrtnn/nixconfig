{pkgs, ...}: {
  programs.foot = {
    enable = true;
    package = pkgs.foot;
    server.enable = true;
    settings = {
      main = {
        include = "${pkgs.foot.themes}/share/foot/themes/gruvbox-dark";
        shell = "${pkgs.zsh}/bin/zsh";
        font = "JetBrainsMono Nerd Font Mono:size=13:fontfeatures=liga 1:fontfeatures=calt 1";
        dpi-aware = true;
      };

      cursor = {
        style = "block";
        blink = true;
      };

      mouse = {
        hide-when-typing = "yes";
      };

      scrollback.lines = 100000;
    };
  };
}
