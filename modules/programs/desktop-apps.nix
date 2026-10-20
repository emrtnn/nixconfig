{
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    home.packages = with pkgs; [
      evince
      ffmpeg
      playerctl
      tor-browser
      telegram-desktop
      (librewolf.override {nativeMessagingHosts = [keepassxc];})
      signal-desktop
      sequoia-sq
    ];
  };
}
