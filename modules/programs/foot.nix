{pkgs, ...}: {
  programs.foot = {
    enable = true;
    package = pkgs.foot;
    server.enable = true;
    settings = {
      main = {
        include = "${pkgs.foot.themes}/share/foot/themes/gruvbox-dark";
        shell = "${pkgs.nushell}/bin/nu";
        font = "JetBrainsMono Nerd Font Mono:size=14";
        pad = "7x2";
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
