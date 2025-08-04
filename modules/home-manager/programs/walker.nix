{ inputs, ... }:

{
  imports = [
    inputs.walker.homeManagerModules.default
  ];

  programs.walker = {
    enable = true;
    runAsService = true;
    config = {
      close_when_open = true;
      hotreload_theme = true;
      keys = {
        accept_typeahead = ["tab"];
        trigger_labels = "lalt";
        next = ["down"];
        prev = ["up"];
        close = ["esc"];
        remove_from_history = ["shift backspace"];
        resume_query = ["ctrl r"];
        toggle_exact_search = ["ctrl m"];
        activation_modifiers = {
          keep_open = "shift";
          alternate = "alt";
        };
        ai = {
          clear_session = ["ctrl x"];
          copy_last_response = ["ctrl c"];
          resume_session = ["ctrl r"];
          run_last_responstruee = ["ctrl e"];
        };
      };
      list = {
        dynamic_sub = true;
        keyboard_scroll_style = "emacs";
        max_entries = 200;
        show_initial_entries = true;
        single_click = true;
        visibility_threshold = 20;
        placeholder = "No Results";
      };
      search = {
        argument_delimiter = "#";
        placeholder = " Search...";
        delay = 0;
        resume_last_query = false;
      };
      activation_mode = {
        labels = "jkl;asdf";
      };
      builtins = {
        hyprland_keybinds = {
          show_sub_when_single = true;
          path = "~/.config/hypr/hyprland.conf";
          weight = 5;
          name = "hyprland_keybinds";
          placeholder = "Hyprland Keybinds";
          switcher_only = true;
          hidden = true;
        };
        applications = {
          weight = 5;
          name = "applications";
          placeholder = " Search...";
          prioritize_new = false;
          hide_actions_with_empty_query = true;
          context_aware = false;
          refresh = true;
          show_sub_when_single = false;
          show_icon_when_single = true;
          show_generic = true;
          history = false;
          icon = "";
          hidden = true;
          actions = {
            enabled = false;
            hide_category = true;
            hide_without_query = true;
          };
        };
        bookmarks = {
          weight = 5;
          placeholder = "Bookmarks";
          name = "bookmarks";
          icon = "bookmark";
          switcher_only = true;
          hidden = true;
        };
        xdph_picker = {
          hidden = true;
          weight = 5;
          placeholder = "Screen/Window Picker";
          show_sub_when_single = true;
          name = "xdphpicker";
          switcher_only = true;
        };
        ai = {
          weight = 5;
          placeholder = "AI";
          name = "ai";
          icon = "help-browser";
          switcher_only = true;
          show_sub_when_single = true;
          anthropic = {
            prompts = [{
              model = "claude-3-7-sonnet-20250219";
              temperature = 1;
              max_tokens = 1000;
              label = "General Assistant";
              prompt = "You are a helpful general assistant. Keep your answers short and precise.";
            }];
          };
        };
        calc = {
          require_number = true;
          weight = 5;
          name = "Calculator";
          icon = "accessories-calculator";
          placeholder = "Calculator";
          min_chars = 3;
          prefix = "=";
        };
        windows = {
          weight = 5;
          icon = "view-restore";
          name = "windows";
          placeholder = "Windows";
          show_icon_when_single = true;
          switcher_only = true;
          hidden = true;
        };
        clipboard = {
          always_put_new_on_top = true;
          exec = "wl-copy";
          weight = 5;
          name = "clipboard";
          avoid_line_breaks = true;
          placeholder = "Clipboard";
          image_height = 300;
          max_entries = 10;
          switcher_only = true;
          hidden = true;
        };
        commands = {
          weight = 5;
          icon = "utilities-terminal";
          switcher_only = true;
          name = "commands";
          placeholder = "Commands";
          hidden = true;
        };
        custom_commands = {
          weight = 5;
          icon = "utilities-terminal";
          name = "custom_commands";
          placeholder = "Custom Commands";
          hidden = true;
        };
        emojis = {
          exec = "wl-copy";
          weight = 5;
          name = "Emojis";
          placeholder = "Emojis";
          switcher_only = true;
          history = true;
          typeahead = true;
          show_unqualified = false;
          prefix = ":";
        };
        symbols = {
          after_copy = "";
          weight = 5;
          name = "symbols";
          placeholder = "Symbols";
          switcher_only = true;
          history = true;
          typeahead = true;
          hidden = true;
        };
        finder = {
          use_fd = true;
          fd_flags = "--ignore-vcs --type file --type directory";
          cmd_alt = "xdg-open $(dirname ~/%RESULT%)";
          weight = 5;
          icon = "file";
          name = "Finder";
          placeholder = "Finder";
          switcher_only = true;
          ignore_gitignore = true;
          refresh = true;
          concurrency = 8;
          show_icon_when_single = true;
          preview_images = true;
          hidden = false;
          prefix = ".";
        };
        runner = {
          eager_loading = true;
          weight = 5;
          icon = "utilities-terminal";
          name = "runner";
          placeholder = "Runner";
          typeahead = true;
          history = true;
          generic_entry = false;
          shell_config = "";
          refresh = true;
          use_fd = false;
          switcher_only = true;
          hidden = true;
        };
        ssh = {
          weight = 5;
          icon = "preferences-system-network";
          name = "ssh";
          placeholder = "SSH";
          switcher_only = true;
          history = true;
          refresh = true;
          hidden = true;
        };
        switcher = {
          weight = 5;
          name = "switcher";
          placeholder = "Switcher";
          prefix = "/";
        };
        websearch = {
          keep_selection = true;
          weight = 5;
          icon = "applications-internet";
          name = "websearch";
          placeholder = "Websearch";
          switcher_only = true;
          hidden = true;
          entries = [
            {
              name = "Google";
              url = "https://www.google.com/search?q=%TERM%";
            }
            {
              name = "DuckDuckGo";
              url = "https://duckduckgo.com/?q=%TERM%";
              switcher_only = true;
            }
            {
              name = "Ecosia";
              url = "https://www.ecosia.org/search?q=%TERM%";
              switcher_only = true;
            }
            {
              name = "Yandex";
              url = "https://yandex.com/search/?text=%TERM%";
              switcher_only = true;
            }
          ];
        };
        dmenu = {
          hidden = true;
          weight = 5;
          name = "dmenu";
          placeholder = "Dmenu";
          switcher_only = true;
          show_icon_when_single = true;
        };
        translation = {
          delay = 1000;
          weight = 5;
          name = "translation";
          icon = "accessories-dictionary";
          placeholder = "Translation";
          switcher_only = true;
          provider = "googlefree";
          hidden = true;
        };
      };
    };
    theme.style = ''
      @define-color selected-text #dca561;
      @define-color text #dcd7ba;
      @define-color base #1f1f28;
      @define-color border #dcd7ba;
      @define-color foreground #dcd7ba;
      @define-color background #1f1f28;
      /* Reset all elements */
      #window,
      #box,
      #search,
      #password,
      #input,
      #prompt,
      #clear,
      #typeahead,
      #list,
      child,
      scrollbar,
      slider,
      #item,
      #text,
      #label,
      #sub,
      #activationlabel {
        all: unset;
      }

      * {
        font-family: 'CaskaydiaMono Nerd Font', monospace;
        font-size: 18px;
      }

      /* Window */
      #window {
        background: transparent;
        color: @text;
      }

      /* Main box container */
      #box {
        background: alpha(@base, 0.95);
        padding: 20px;
        border: 2px solid @border;
        border-radius: 0px;
      }

      /* Search container */
      #search {
        background: @base;
        padding: 10px;
        margin-bottom: 0;
      }

      /* Hide prompt icon */
      #prompt {
        opacity: 0;
        min-width: 0;
        margin: 0;
      }

      /* Hide clear button */
      #clear {
        opacity: 0;
        min-width: 0;
      }

      /* Input field */
      #input {
        background: none;
        color: @text;
        padding: 0;
      }

      #input placeholder {
        opacity: 0.5;
        color: @text;
      }

      /* Hide typeahead */
      #typeahead {
        opacity: 0;
      }

      /* List */
      #list {
        background: transparent;
      }

      /* List items */
      child {
        padding: 0px 12px;
        background: transparent;
        border-radius: 0;
      }

      child:selected,
      child:hover {
        background: transparent;
      }

      /* Item layout */
      #item {
        padding: 0;
      }

      /* Icon */
      #icon {
        margin-right: 10px;
        -gtk-icon-transform: scale(0.7);
      }

      /* Text */
      #text {
        color: @text;
        padding: 14px 0;
      }

      #label {
        font-weight: normal;
      }

      /* Selected state */
      child:selected #text,
      child:selected #label,
      child:hover #text,
      child:hover #label {
        color: @selected-text;
      }

      /* Hide sub text */
      #sub {
        opacity: 0;
        font-size: 0;
        min-height: 0;
      }

      /* Hide activation label */
      #activationlabel {
        opacity: 0;
        min-width: 0;
      }

      /* Scrollbar styling */
      scrollbar {
        opacity: 0;
      }

      /* Hide spinner */
      #spinner {
        opacity: 0;
      }

      /* Hide AI elements */
      #aiScroll,
      #aiList,
      .aiItem {
        opacity: 0;
        min-height: 0;
      }

      /* Bar entry (switcher) */
      #bar {
        opacity: 0;
        min-height: 0;
      }

      .barentry {
        opacity: 0;
      }
    '';
  };
}
