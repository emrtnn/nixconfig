{lib, pkgs, ...}: {
  boot = {
    kernelParams = lib.mkBefore [
      "quiet"
      "splash"
      "boot.initrd.verbose=false"
    ];

    initrd = {
      enable = true;
      systemd.enable = true;
      verbose = false;
    };

    consoleLogLevel = 0;
    plymouth = {
      enable = true;
      font = "${pkgs.jetbrains-mono}/share/fonts/truetype/JetBrainsMono-Regular.ttf";
      theme = "splash";
      themePackages = with pkgs; [
        (adi1090x-plymouth-themes.override {
          selected_themes = ["splash"];
        })
      ];
    };
  };
}
