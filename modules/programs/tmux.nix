{pkgs, ...}: {
  programs.tmux = {
    enable = true;

    # --- Core Options ---
    prefix = "C-a";
    baseIndex = 1;
    keyMode = "vi";
    mouse = true;
    historyLimit = 100000;
    terminal = "xterm-256color";

    shell = "${pkgs.nushell}/bin/nu";

    # --- Plugins ---
    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      tmux-fzf
      {
        plugin = mkTmuxPlugin {
          pluginName = "smart-splits";
          version = "v2.0.5";
          rtpFilePath = "smart-splits.tmux";
          src = pkgs.fetchFromGitHub {
            owner = "mrjones2014";
            repo = "smart-splits.nvim";
            rev = "v2.0.5";
            sha256 = "sha256-EqnSGTyADvIpHxN3jZxwetENdqv/XUossUzrEvLHHMk=";
          };
        };

        # 2. Configure using the official docs variables
        extraConfig = ''
          set -g @smart-splits_move_left_key  'C-h'
          set -g @smart-splits_move_down_key  'C-j'
          set -g @smart-splits_move_up_key    'C-k'
          set -g @smart-splits_move_right_key 'C-l'

          set -g @smart-splits_resize_left_key  'M-h'
          set -g @smart-splits_resize_down_key  'M-j'
          set -g @smart-splits_resize_up_key    'M-k'
          set -g @smart-splits_resize_right_key 'M-l'

          set -g @smart-splits_resize_step_size '3'
        '';
      }
      {
        plugin = tmux-floax;
        extraConfig = ''
          set -g @floax-bind 'p'
          set -g @floax-width '80%'
          set -g @floax-height '80%'
          set -g @floax-text-color 'default'
          set -g @floax-change-path 'true'
        '';
      }
      {
        plugin = tmux-sessionx;
        extraConfig = ''
          set -g @sessionx-bind 'o'
          set -g @sessionx-window-height '85%'
          set -g @sessionx-window-width '75%'
        '';
      }
      {
        plugin = fzf-tmux-url;
        extraConfig = ''
          set -g @fzf-url-open "brave"
          set -g @fzf-url-bind 'u'
        '';
      }
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-processes 'ssh'";
      }
      {
        plugin = continuum;
        extraConfig = "set -g @continuum-restore 'on'";
      }
      {
        plugin = gruvbox;
        extraConfig = "set -g @tmux-gruvbox 'dark'";
      }
    ];

    # --- Extra Configuration ---
    extraConfig = ''
      # Status & Visuals
      set -g status-position top
      set -g renumber-windows on

      # Allow image preview in Yazi (passthrough)
      set -g allow-passthrough on
      set -ga update-environment TERM
      set -ga update-environment TERM_PROGRAM

      # Keybindings
      unbind C-b
      bind-key C-a send-prefix

      bind ^X lock-server
      bind c new-window -c "#{pane_current_path}"
      bind ^D detach
      bind * list-clients
      bind ^W choose-window

      # Splits and Navigation
      bind S choose-session
      bind s split-window -v -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R
      bind ^C kill-pane
    '';
  };
}
