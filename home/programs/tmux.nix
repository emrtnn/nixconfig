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
        plugin = gruvbox;
        extraConfig = ''
          set -g @tmux-gruvbox 'dark'
          set -g @tmux-gruvbox-left-status-a '#{?client_prefix,PREFIX ,}#S'
        '';
      }
      {
        plugin = resurrect;
        extraConfig = ''
          # Restore layouts and working directories, not SSH or agent commands.
          set -g @resurrect-processes 'false'
          set -g @resurrect-capture-pane-contents 'off'
        '';
      }
      {
        # Keep last: continuum adds its autosave hook to the theme's status-right.
        plugin = continuum;
        extraConfig = ''
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

      # Warm, distinct borders make the focused pane obvious in busy layouts.
      set -g pane-border-style 'fg=#d79921'
      set -g pane-active-border-style 'fg=#fabd2f,bold'
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
