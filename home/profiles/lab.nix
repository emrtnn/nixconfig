{pkgs, ...}: {
  imports = [
    ./base.nix
    ./terminal.nix
    ../../modules/home/desktop/browser.nix
    ../../modules/home/desktop/apps.nix
    ../../modules/home/desktop/appearance.nix
    ../../modules/home/programs/hacking.nix
    ../../modules/home/personal/agents.nix
    ../../modules/home/personal/credentials.nix
  ];

  home.packages = with pkgs; [
    tor-browser
    tree
  ];

  programs = {
    git.settings.user = {
      name = "emrtnn";
      email = "emrtnn@proton.me";
    };

    jujutsu.settings.user = {
      name = "emrtnn";
      email = "emrtnn@proton.me";
    };
  };

  xdg.mimeApps.defaultApplications."application/pdf" = "org.gnome.Evince.desktop";
}
