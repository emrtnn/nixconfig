{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../../home/development.nix
    ../../home/programs/helium.nix
    ../../home/programs/dolphin.nix
    ../../home/programs/imv.nix
    ../../home/desktop/appearance.nix
    ../../home/desktop/wallpapers.nix
    ../../home/programs/hacking.nix
    ../../home/programs/pi.nix
    ../../home/programs/tmux.nix
    ../../home/security/sops.nix
    ../../home/security/password-store.nix
    ../../home/desktop/bspwm.nix
  ];

  home = {
    username = "impuremonad";
    homeDirectory = "/home/impuremonad";
    stateVersion = "26.05";
    packages = with pkgs; [
      evince
      ffmpeg
      playerctl
      proton-vpn
      tor-browser
      telegram-desktop
      firefox
    ];
    file.".face.png".source = ../../assets/.face;
    sessionVariables.BRAVE_API_KEY_FILE = "${config.home.homeDirectory}/.config/sops-nix/secrets/brave_api_key";
  };

  sops = {
    defaultSopsFile = ../../secrets/secrets.yaml;
    age.keyFile = "/home/impuremonad/.config/sops/age/keys.txt";
    secrets.brave_api_key = {};
  };

  programs.git.settings.user = {
    name = "emrtnn";
    email = "emrtnn@proton.me";
  };
  programs.jujutsu.settings = {
    user = {
      name = "emrtnn";
      email = "emrtnn@proton.me";
    };
    signing = {
      backend = "gpg";
      key = "197CB7FC535093C4";
      sign-all = true;
      behavior = "own";
    };
  };

  xdg.mimeApps.defaultApplications."application/pdf" = "org.gnome.Evince.desktop";
}
