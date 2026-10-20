{
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    home.packages = with pkgs; [
      pi-coding-agent
      nodejs_26
      pnpm
    ];

    # Global npm/pnpm installs can't go into the read-only /nix/store.
    home.sessionVariables.NPM_CONFIG_PREFIX = "$HOME/.npm-global";
    home.sessionPath = [
      "$HOME/.npm-global/bin"
      "$HOME/.local/share/pnpm/bin"
    ];
  };
}
