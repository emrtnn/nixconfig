{ config, lib, pkgs, ... }:

{
  fonts = {
      packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      nerd-fonts.jetbrains-mono
			nerd-fonts.caskaydia-cove
			nerd-fonts.geist-mono
      twemoji-color-font
    ];
	};
}
