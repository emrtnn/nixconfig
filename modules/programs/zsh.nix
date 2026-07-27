{config, ...}: {
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
      ignoreAllDups = true;
      extended = true;
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
      # Eza
      ls = "eza";
      l = "eza -l";
      ll = "eza -lh";
      lt = "eza --tree";
      cat = "bat";

      pfzf = "fzf --preview='bat --color=always {}'";
      nfzf = "nvim $(fzf -m --preview='bat --color=always {}')";

      gc = "git commit -m";
      gco = "git checkout";
      gb = "git branch";
      gp = "git push";
      gcp = "git cherry-pick";
      gt = "git tag";
      ga = "git add";
      gs = "git status";
      gl = "git log --graph --pretty=format:'%C(yellow)%h (%Creset%Cgreen%p%Creset%C(yellow))%Creset -%Cred%d%Creset %s %Cgreen(%cr)%Creset %C(bold blue)<%an>%Creset' --abbrev-commit --all";
      lg = "lazygit";
      gd = "git diff";
      gds = "git diff --staged";

      jl = "jj log -r 'all()'";
      jd = "hunk diff";
      jdesc = "jj describe";
      jn = "jj new";
      js = "jj status --no-pager";
      jshow = "jj show --no-pager";
    };

    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    initContent = ''
      # Vi Mode
      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd 'v' visual-mode
      bindkey -M vicmd '^o' edit-command-line
      bindkey -M viins '^?' backward-delete-char

      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^H' backward-kill-word

      # Cursor shape: blinking block for insert, static block for normal/visual
      _cursor_block_blink() { printf '\e[1 q'; }
      _cursor_block_static() { printf '\e[2 q'; }
      zle-keymap-select() {
        case $KEYMAP in
          vicmd|visual) _cursor_block_static ;;
          *)            _cursor_block_blink ;;
        esac
      }
      zle -N zle-keymap-select
      zle-line-init() { _cursor_block_blink; }
      zle -N zle-line-init

      # Ignore completion case
      zstyle ':completion:*' matcher-list \
        'm:{a-z}={A-Za-z}' \
        'r:|=*' \
        'l:|=* r:|=*'
      zstyle ":completion:*" list-colors "\$\{(s.:.)LS_COLORS\}"
      zstyle ":completion:*" menu yes select
      zstyle ":completion:*" group-name
      zstyle ":completion:*" verbose yes
      zstyle ":completion:*:descriptions" format '%F{yellow}%d%f'
      zstyle ":completion:*" use-cache on
      zstyle ":completion:*" cache-path ${config.xdg.cacheHome}/zsh/zcompcache
      zstyle ':completion:*' squeeze-slashes true
      zstyle ':completion:*' special-dirs true

      setopt NUMERIC_GLOB_SORT
      setopt GLOB_DOTS

      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt PUSHD_MINUS
      setopt PUSHD_SILENT
      setopt NO_BEEP
      setopt COMPLETE_IN_WORD
      setopt ALWAYS_TO_END
      setopt HIST_VERIFY
      setopt AUTO_CD
      setopt AUTO_PARAM_SLASH
      setopt AUTO_REMOVE_SLASH
      setopt AUTO_LIST
    '';
  };
}
