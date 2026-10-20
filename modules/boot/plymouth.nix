{
  flake.modules.nixos.workstation = {
    lib,
    pkgs,
    ...
  }: {
    boot.plymouth = {
      enable = true;
      font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
      theme = "splash";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["splash"];
        })
      ];
    };

    # Quiet, splash-screen boot driving the Plymouth theme.
    boot.kernelParams = lib.mkBefore [
      "quiet"
      "splash"
    ];
  };
}
