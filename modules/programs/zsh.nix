{pkgs, ...}: {
  programs.eza = {
    enable = true;
    enableZshIntegration = true;
    icons = "auto";
    colors = "always";
    git = true;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    autocd = true;

    history = {
      size = 100000;
      save = 100000;
      share = true;
      ignoreDups = true;
    };

    defaultKeymap = "viins";

    shellAliases = {
      cat = "bat";
      grep = "rg";
      pfzf = "fzf --preview='bat --color=always {}'";
      nfzf = "nvim $(fzf -m --preview='bat --color=always {}')";

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

    profileExtra = ''
      if uwsm check may-start; then
        exec uwsm start hyprland-uwsm.desktop
      fi
    '';

    sessionVariables = {
      EDITOR = "nvim";
    };

    initContent = ''
      # Vi Mode
      bindkey "^?" backward-delete-char

      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd 'v' visual-mode
      bindkey -M vicmd '^v' edit-command-line

      fastfetch
    '';
  };
}
