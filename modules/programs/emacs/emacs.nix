{
  # Doom Emacs. Nix provides Emacs, native bits and the daemon; Doom itself
  # lives in ~/.config/emacs (cloned once, managed by `doom`), and the private
  # config (~/.config/doom) is symlinked from ./doom so edits need no rebuild.
  # Language servers come from modules/programs/nvim/_toolchain.nix.
  flake.modules.homeManager.workstation = {
    pkgs,
    config,
    lib,
    ...
  }: {
    programs.emacs = {
      enable = true;
      package = pkgs.emacs-pgtk;
      extraPackages = epkgs: [
        epkgs.treesit-grammars.with-all-grammars
        epkgs.vterm # needs its compiled module; Doom prefers the built-in one
      ];
    };

    services.emacs = {
      enable = true;
      client.enable = true;
      startWithUserSession = "graphical";
    };

    # git, ripgrep and fd come from the base module.
    home.packages = with pkgs; [
      emacs-all-the-icons-fonts
      nerd-fonts.symbols-only
    ];

    home.sessionPath = ["${config.home.homeDirectory}/.config/emacs/bin"];

    xdg.configFile."doom".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nixconfig/modules/programs/emacs/doom";

    # Clone Doom once; afterwards `doom sync` / `doom upgrade` own it.
    # Modules live in a submodule (sources/doom+), so recurse. A fresh clone
    # still needs a manual `doom sync` before the daemon can start.
    home.activation.doomEmacs = lib.hm.dag.entryAfter ["linkGeneration"] ''
      if [ ! -d "$HOME/.config/emacs" ]; then
        run ${pkgs.git}/bin/git clone --depth 1 --recurse-submodules --shallow-submodules \
          https://github.com/doomemacs/doomemacs "$HOME/.config/emacs"
      fi
    '';
  };
}
