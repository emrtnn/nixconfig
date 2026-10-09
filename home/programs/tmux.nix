{pkgs, ...}: let
  copyToClipboard = pkgs.writeShellScript "tmux-copy" ''
    if [ -n "''${WAYLAND_DISPLAY:-}" ]; then
      exec ${pkgs.wl-clipboard}/bin/wl-copy
    else
      exec ${pkgs.xclip}/bin/xclip -in -selection clipboard
    fi
  '';
in {
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    baseIndex = 1;
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    resizeAmount = 3;
    mouse = true;
    focusEvents = true;
    escapeTime = 10;
    historyLimit = 100000;
    terminal = "tmux-256color";
    shell = "${pkgs.zsh}/bin/zsh";

    plugins = with pkgs.tmuxPlugins; [
      # Ctrl+h/j/k/l crosses Neovim splits and tmux panes without a prefix.
      vim-tmux-navigator
      {
        plugin = resurrect;
        extraConfig = ''
          # Restore layouts and working directories, not SSH or agent commands.
          set -g @resurrect-processes 'false'
          set -g @resurrect-capture-pane-contents 'off'
        '';
      }
      {
        # Keep last: continuum adds its autosave hook to status-right.
        plugin = continuum;
        extraConfig = ''
          # Home Manager loads plugins before the main extraConfig. Initialize
          # status-right here so continuum's autosave hook survives.
          set -g status-right '#[fg=#3ddbd9,bg=#262626] #H #[fg=#dde1e6,bg=#161616] %Y-%m-%d #[fg=#78a9ff]%H:%M '
          set -g @continuum-save-interval '5'
          set -g @continuum-restore 'on'
        '';
      }
    ];

    extraConfig = ''
      set -g renumber-windows on
      set -g status-position top
      set -g status-interval 5
      set -g display-time 1500

      # Foot/Kitty capabilities, focus reporting, and Yazi image passthrough.
      set -as terminal-features ',xterm-kitty:RGB:extkeys,foot*:RGB:extkeys'
      set -g extended-keys on
      set -g extended-keys-format csi-u
      set -g allow-passthrough on
      set -ga update-environment ' WAYLAND_DISPLAY XDG_RUNTIME_DIR DBUS_SESSION_BUS_ADDRESS TERM_PROGRAM'

      # Native Oxocarbon styling; status-right is initialized before continuum.
      set -g status-style 'bg=#161616,fg=#f2f4f8'
      set -g status-left-length 60
      set -g status-right-length 100
      set -g status-left '#[fg=#161616,bg=#{?client_prefix,#be95ff,#3ddbd9},bold] #{?client_prefix,PREFIX ,}#S#[default] '
      set -g window-status-style 'bg=#262626,fg=#dde1e6'
      set -g window-status-format ' #I:#W#{?window_flags, #F,} '
      set -g window-status-current-style 'bg=#78a9ff,fg=#161616,bold'
      set -g window-status-current-format ' #I:#W#{?window_flags, #F,} '
      set -g window-status-activity-style 'bg=#262626,fg=#42be65'
      set -g window-status-bell-style 'bg=#ee5396,fg=#161616,bold'
      set -g window-status-last-style 'fg=#be95ff'
      set -g window-status-separator ' '
      set -g message-style 'bg=#262626,fg=#f2f4f8'
      set -g message-command-style 'bg=#262626,fg=#3ddbd9'
      set -g mode-style 'bg=#393939,fg=#f2f4f8'
      set -g clock-mode-colour '#78a9ff'
      set -g menu-style 'bg=#262626,fg=#f2f4f8'
      set -g menu-selected-style 'bg=#393939,fg=#3ddbd9,bold'
      set -g menu-border-style 'fg=#525252'
      set -g pane-border-style 'fg=#525252'
      set -g pane-active-border-style 'fg=#78a9ff,bold'
      set -g pane-border-status top
      set -g pane-border-format ' #{pane_index}: #{pane_current_command} #{?pane_active,*,} '
      set -g monitor-bell on
      set -g bell-action other
      set -g visual-bell off

      # Keep tmux's native session/window pickers (prefix+s / prefix+w).
      # New windows and both native and mnemonic splits follow the current pane.
      bind c new-window -c '#{pane_current_path}'
      bind v split-window -h -c '#{pane_current_path}'
      bind s split-window -v -c '#{pane_current_path}'
      bind p display-popup -E -w 80% -h 80% -d '#{pane_current_path}'
      bind r source-file ~/.config/tmux/tmux.conf \; display-message 'tmux configuration reloaded'
      bind x kill-pane

      # Bind 'e' to sessions tree explorer since its default keybind was 's'
      bind e choose-tree -s

      # Native vi copy mode; both keyboard and mouse copy to CLIPBOARD on X11.
      # Choose the backend at copy time, rather than by installed executables.
      set -s set-clipboard external
      set -s copy-command '${copyToClipboard}'
      bind -T copy-mode-vi v send-keys -X begin-selection
      bind -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel
      bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel
      bind -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel
    '';
  };
}
