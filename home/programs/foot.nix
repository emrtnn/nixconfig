{pkgs, ...}: let
  upstreamTheme = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/Oxocarbon-Theme/foot/7a9f6de36a2ccc9c9d29066b9ba1f69002c65a0a/oxocarbon-dark.ini";
    hash = "sha256-4+FLGCs/uYn48Zvm5cVPR/+lkwRNlRTdpnT7p+ePlXw=";
  };
  # Adapt the upstream port to Foot's current section name.
  theme = pkgs.runCommand "oxocarbon-foot.ini" {} ''
    substitute ${upstreamTheme} "$out" --replace-fail '[colors]' '[colors-dark]'
  '';
in {
  programs.foot = {
    enable = true;
    package = pkgs.foot.override {
      allowPgo = true;
    };
    server.enable = true;
    settings = {
      main = {
        include = "${theme}";
        shell = "${pkgs.zsh}/bin/zsh";
        font = "JetBrainsMono Nerd Font Mono:size=14";
        pad = "7x2";
        dpi-aware = true;
      };

      cursor = {
        style = "block";
        blink = true;
      };

      colors-dark = {
        alpha = 1;
        blur = false;
      };

      mouse = {
        hide-when-typing = "yes";
      };

      scrollback.lines = 100000;
    };
  };
}
