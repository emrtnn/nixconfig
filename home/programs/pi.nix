{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    pi-coding-agent
    nodejs_26
    pnpm
  ];

  home.file.".pi" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixconfig/dotfiles/pi";
    recursive = true;
  };
}
