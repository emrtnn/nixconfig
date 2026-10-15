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
      grep = "rg";
      find = "fd";
      tree = "eza --tree";

      pfzf = "fzf --preview='bat --color=always {}'";
      nfzf = "nvim $(fzf -m --preview='bat --color=always {}')";

      gc = "git commit -m";
      gl = "git plog";
      gsignver = "git plog --show-signature";
      gco = "git checkout";
      gb = "git branch";
      gp = "git push";
      gcp = "git cherry-pick";
      gt = "git tag";
      ga = "git add";
      gs = "git status";
      lg = "lazygit";
      gd = "tuicr -r HEAD";
      gds = "git diff --staged";

      jl = "jj log -r 'all()'";
      jd = "tuicr -r @";
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
      # Export API keys from sops secret files (read at runtime, never stored in the nix store)
      [[ -r "$EXA_API_KEY_FILE" ]] && export EXA_API_KEY="$(<"$EXA_API_KEY_FILE")"
      [[ -r "$BRAVE_API_KEY_FILE" ]] && export BRAVE_API_KEY="$(<"$BRAVE_API_KEY_FILE")"

      # select by name and copy the target path without a newline.
      wordlist-copy() {
        local selected target
        selected=$(
          wordlists |
            rg --color=never -oP '(?<=──).*(?= ->) -> .*' |
            fzf --no-multi --delimiter=' -> ' --with-nth=1 \
            --preview='bat --color=always --style=numbers --line-range=:500 {2}'
        ) || return
        [[ -n "$selected" ]] || return
        target=''${selected#* -> }

        if [[ -n "$WAYLAND_DISPLAY" ]]; then
          printf '%s' "$target" | wl-copy
        else
          printf '%s' "$target" | xclip -selection clipboard
        fi
      }

      # Vi Mode
      autoload -U edit-command-line
      zle -N edit-command-line
      bindkey -M vicmd 'v' visual-mode
      bindkey -M vicmd '^o' edit-command-line
      bindkey -M viins '^?' backward-delete-char

      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word
      bindkey '^H' backward-kill-word

      # Shift+Tab cycles completions backwards
      zmodload zsh/complist
      bindkey '^[[Z' reverse-menu-complete
      bindkey -M menuselect '^[[Z' reverse-menu-complete

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
      zstyle ':completion:*' special-dirs false

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
