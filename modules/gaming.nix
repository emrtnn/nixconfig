{pkgs, ...}: {
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
      extraCompatPackages = with pkgs; [
        proton-ge-bin
      ];
    };

    gamemode = {
      enable = true;
      settings = {
        general = {
          renice = 10;
          softrealtime = "auto";
        };
      };
    };
  };

  environment = {
    systemPackages = with pkgs; [
      heroic
      umu-launcher

      winetricks
      protontricks

      mangohud
      gamescope

      vulkan-tools
      mesa-demos
    ];
  };
}
