{inputs, ...}: {
  programs.nushell = {
    enable = true;

    shellAliases = {
      pfzf = "fzf --preview='bat --color=always {}'";
      cat = "bat";
      gc = "git commit";
      gp = "git push";
      ga = "git add";
      gs = "git status";
      gl = "git log --graph --pretty=format:'%C(yellow)%h (%Creset%Cgreen%p%Creset%C(yellow))%Creset -%Cred%d%Creset %s %Cgreen(%cr)%Creset %C(bold blue)<%an>%Creset' --abbrev-commit --all";
      lg = "lazygit";
      gd = "git diff";
      gds = "git diff --staged";
    };

    environmentVariables = {
      EDITOR = "hx";
      VISUAL = "hx";
      PROMPT_INDICATOR = " ";
      PROMPT_COMMAND_RIGHT = "''";
      PROMPT_MULTILINE_INDICATOR = "''";
      PROMPT_COMMAND = "''";
      TRANSIENT_PROMPT_COMMAND = null;
      CARAPACE_BRIDGES = "'zsh,fish,bash,inshellisense'";
    };

    extraConfig = ''
      # --- History & Behavior ---
      $env.config.history.file_format = "sqlite"
      $env.config.history.isolation = false
      $env.config.history.max_size = 10_000_000
      $env.config.history.sync_on_enter = true

      $env.config.show_banner = false
      $env.config.edit_mode = "vi"
      $env.config.rm.always_trash = false
      $env.config.recursion_limit = 100

      # --- Completions ---
      $env.config.completions.algorithm = "substring"
      $env.config.completions.sort = "smart"
      $env.config.completions.case_sensitive = false
      $env.config.completions.quick = true
      $env.config.completions.partial = true
      $env.config.completions.use_ls_colors = true

      # --- Terminal Features ---
      $env.config.use_kitty_protocol = true
      $env.config.bracketed_paste = true
      $env.config.use_ansi_coloring = "auto"
      $env.config.highlight_resolved_externals = true

      $env.config.error_style = "fancy"
      $env.config.display_errors.exit_code = false
      $env.config.display_errors.termination_signal = true
      $env.config.footer_mode = 25

      # --- Table Settings ---
      $env.config.table.mode = "single"
      $env.config.table.index_mode = "always"
      $env.config.table.show_empty = true
      $env.config.table.padding.left = 1
      $env.config.table.padding.right = 1
      $env.config.table.trim.methodology = "wrapping"
      $env.config.table.trim.wrapping_try_keep_words = true
      $env.config.table.trim.truncating_suffix = "..."
      $env.config.table.header_on_separator = true
      $env.config.table.footer_inheritance = true
      $env.config.table.missing_value_symbol = $"(ansi magenta_bold)nope(ansi reset)"

      # --- Formatting ---
      $env.config.datetime_format.normal = $"(ansi blue_bold)%Y(ansi reset)(ansi yellow)-(ansi blue_bold)%m(ansi reset)(ansi yellow)-(ansi blue_bold)%d(ansi reset)(ansi black)T(ansi magenta_bold)%H(ansi reset)(ansi yellow):(ansi magenta_bold)%M(ansi reset)(ansi yellow):(ansi magenta_bold)%S(ansi reset)"
      $env.config.filesize.unit = "metric"
      $env.config.filesize.show_unit = true
      $env.config.filesize.precision = 1
      $env.config.float_precision = 2
      $env.config.ls.use_ls_colors = true

      # --- Hooks ---
      $env.config.hooks.pre_prompt = []
      $env.config.hooks.pre_execution = [
        {||
          commandline
          | str trim
          | if ($in | is-not-empty) { print $"(ansi title)($in) — nu(char bel)" }
        }
      ]

      $env.config.hooks.display_output = {||
        tee { table --expand | print }
        | try { if $in != null { $env.last = $in } }
      }

      # --- Custom Functions ---
      def _ []: nothing -> any {
        $env.last?
      }

      def nu-highlight-default [] {
        let input = $in
        $env.config.color_config = {}
        $input | nu-highlight
      }

      def rcopy [] {
        ls **/* | where type == file
        | each { |it| $"($it.name)\n(open $it.name)\n" }
        | str join "\n"
        | wl-copy
      }

      def "nu-keybind commandline-copy" []: nothing -> nothing {
        commandline
        | nu-highlight-default
        | [
          "```ansi"
          $in
          "```"
        ]
        | str join (char nl)
        | clip copy --ansi
      }

      # Your custom 'nfzf' function from alias.nu
      def nfzf [] {
          try {
              let selected_file = (fzf --preview="bat --color=always {}" | str trim)
              if ($selected_file != "" and ($selected_file | path exists)) {
                  hx $selected_file
              } else {
                  print "No file selected or file doesn't exist"
              }
          } catch {
              print "fzf was cancelled or failed"
          }
      }

      # --- Keybindings ---
      $env.config.keybindings ++= [
        {
          name: copy_color_commandline
          modifier: control_alt
          keycode: char_c
          mode: [ emacs vi_insert vi_normal ]
          event: {
            send: executehostcommand
            cmd: 'nu-keybind commandline-copy'
          }
        }
      ]

      # --- Color Config ---
      $env.config.color_config.bool = {|| if $in { "light_green_bold" } else { "light_red_bold" } }
      $env.config.color_config.string = {|| if $in =~ "^(#|0x)[a-fA-F0-9]+$" { $in | str replace "0x" "#" } else { "white" } }
      $env.config.color_config.row_index = "light_yellow_bold"
      $env.config.color_config.header = "light_yellow_bold"

      # --- Startup ---
      fastfetch
    '';
  };
}
