{ config, lib, pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      nerdfonts.jetbrains-mono
			nerdfonts.caskaydia-cove
			nerdfonts.geist-mono
      twemoji-color-font
    ];
	};
}
