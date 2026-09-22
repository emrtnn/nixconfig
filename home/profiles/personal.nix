{pkgs, ...}: {
  imports = [
    ./base.nix
    ./terminal.nix
    ../../modules/home/desktop/browser.nix
    ../../modules/home/desktop/apps.nix
    ../../modules/home/desktop/appearance.nix
    ../../modules/home/desktop/keyring.nix
    ../../modules/home/programs/hacking.nix
    ../../modules/home/personal/apps.nix
    ../../modules/home/personal/agents.nix
    ../../modules/home/personal/credentials.nix
  ];

  home.packages = [pkgs.tor-browser];

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
}
