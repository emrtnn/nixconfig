{pkgs, ...}: {
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
}
