{
  pkgs,
  config,
  ...
}: {
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    colors = "always";
    git = true;
  };

  programs.zsh = {
    enable = true;
    dotDir = "${config.xdg.configHome}/zsh";
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;

    history = {
      size = 10000;
      save = 10000;
      share = true;
      append = true;
      expireDuplicatesFirst = true;
      saveNoDups = true;
      findNoDups = true;
      ignoreDups = true;
      ignoreSpace = true;
    };

    historySubstringSearch = {
      enable = true;
      searchUpKey = "^p";
      searchDownKey = "^n";
    };

    defaultKeymap = "viins";

    shellAliases = {
      ls = "eza";
      cat = "bat";
      grep = "rg";
      pfzf = "fzf --preview='bat --color=always {}'";
      nfzf = "hx $(fzf -m --preview='bat --color=always {}')";

      gc = "git commit";
      gp = "git push";
      ga = "git add";
      gs = "git status";
      gl = "git log --graph --pretty=format:'%C(yellow)%h (%Creset%Cgreen%p%Creset%C(yellow))%Creset -%Cred%d%Creset %s %Cgreen(%cr)%Creset %C(bold blue)<%an>%Creset' --abbrev-commit --all";
      lg = "lazygit";
      gd = "git diff";
      gds = "git diff --staged";

      nrs = "nixos-rebuild switch --flake";
      nb = "nix build";
      nd = "nix develop";
      nr = "nix run";
      ns = "nix shell";
    };

    sessionVariables = {
      EDITOR = "hx";
    };

    initContent = ''
      # Vi Mode
      bindkey "^?" backward-delete-char
      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd 'v' visual-mode
      bindkey -M vicmd '^v' edit-command-line

      # Ignore completion case
      zstyle ":completion:*" matcher-list "m:{a-z}={A-Za-z}"
      zstyle ":completion:*" list-colors "\$\{(s.:.)LS_COLORS\}"

      # fastfetch
    '';
  };
}
