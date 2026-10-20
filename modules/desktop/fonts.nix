{
  flake.modules.nixos.desktop = {
    lib,
    pkgs,
    ...
  }: {
    fonts = {
      packages = lib.mkAfter (with pkgs; [
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
        nerd-fonts.jetbrains-mono
        nerd-fonts.caskaydia-cove
        nerd-fonts.geist-mono
        nerd-fonts.iosevka
        twemoji-color-font
        material-symbols
      ]);
    };
  };
}
