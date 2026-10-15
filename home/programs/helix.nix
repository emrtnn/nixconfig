{
  pkgs,
  lib,
  ...
}: let
  c = import ../themes/caelus.nix;
in {
  programs.helix = {
    enable = true;
    # Same syntax roles as dotfiles/nvim/colors/caelus.lua.
    themes.caelus = {
      "ui.background" = {};
      "ui.text" = c.fg;
      "ui.text.focus" = {
        fg = c.fg;
        modifiers = ["bold"];
      };
      "ui.text.inactive" = c.gray6;
      "ui.text.directory" = c.blue;
      "ui.cursor" = {
        fg = c.bg;
        bg = c.gray8;
      };
      "ui.cursor.primary" = {
        fg = c.bg;
        bg = c.orange;
      };
      "ui.cursor.match" = {
        fg = c.orange;
        bg = c.gray2;
        modifiers = ["bold"];
      };
      "ui.cursorline.primary" = {bg = c.gray1;};
      "ui.selection" = {bg = c.gray2;};
      "ui.selection.primary" = {bg = c.gray3;};
      "ui.linenr" = c.gray4;
      "ui.linenr.selected" = {
        fg = c.orange;
        modifiers = ["bold"];
      };
      "ui.gutter" = {};
      "ui.statusline" = {
        fg = c.gray9;
        bg = c.gray0;
      };
      "ui.statusline.inactive" = {
        fg = c.gray5;
        bg = c.gray0;
      };
      "ui.statusline.normal" = {
        fg = c.bg;
        bg = c.orange;
        modifiers = ["bold"];
      };
      "ui.statusline.insert" = {
        fg = c.bg;
        bg = c.green;
        modifiers = ["bold"];
      };
      "ui.statusline.select" = {
        fg = c.bg;
        bg = c.magenta;
        modifiers = ["bold"];
      };
      "ui.statusline.separator" = c.gray3;
      "ui.bufferline" = {
        fg = c.gray7;
        bg = c.gray0;
      };
      "ui.bufferline.active" = {
        fg = c.bg;
        bg = c.orange;
        modifiers = ["bold"];
      };
      "ui.bufferline.background" = {bg = c.gray0;};
      "ui.popup" = {
        fg = c.fg;
        bg = c.gray0;
      };
      "ui.popup.info" = {
        fg = c.fg;
        bg = c.gray0;
      };
      "ui.window" = c.gray3;
      "ui.help" = {
        fg = c.fg;
        bg = c.gray0;
      };
      "ui.menu" = {
        fg = c.fg;
        bg = c.gray1;
      };
      "ui.menu.selected" = {
        fg = c.bg;
        bg = c.orange;
        modifiers = ["bold"];
      };
      "ui.menu.scroll" = {
        fg = c.gray4;
        bg = c.gray2;
      };
      "ui.picker.header" = {
        fg = c.orange;
        modifiers = ["bold"];
      };
      "ui.virtual" = c.gray3;
      "ui.virtual.whitespace" = c.gray2;
      "ui.virtual.indent-guide" = c.gray2;
      "ui.virtual.ruler" = {bg = c.gray1;};
      "ui.virtual.inlay-hint" = {
        fg = c.gray5;
        modifiers = ["italic"];
      };
      "ui.virtual.jump-label" = {
        fg = c.bg;
        bg = c.orange;
        modifiers = ["bold"];
      };
      "ui.highlight" = {bg = c.gray2;};

      comment = {
        fg = c.gray6;
        modifiers = ["italic"];
      };
      keyword = c.orange;
      "keyword.directive" = c.orangeLight;
      "keyword.control.import" = c.orangeLight;
      "keyword.control.return" = {
        fg = c.orange;
        modifiers = ["italic"];
      };
      operator = c.gray8;
      punctuation = c.gray8;
      "punctuation.special" = c.orangeLight;
      function = c.yellow;
      "function.builtin" = {
        fg = c.yellow;
        modifiers = ["italic"];
      };
      "function.macro" = c.orangeLight;
      type = c.cyan;
      "type.builtin" = {
        fg = c.cyan;
        modifiers = ["italic"];
      };
      constructor = c.cyan;
      attribute = c.cyan;
      string = c.green;
      "string.regexp" = c.orangeLight;
      "string.special" = c.orangeLight;
      "string.special.url" = {
        fg = c.blue;
        modifiers = ["underlined"];
      };
      "constant.character.escape" = c.orangeLight;
      constant = c.magenta;
      "constant.numeric" = c.magenta;
      "constant.builtin" = {
        fg = c.magenta;
        modifiers = ["bold"];
      };
      variable = c.fg;
      "variable.builtin" = c.redLight;
      "variable.parameter" = {
        fg = c.gray9;
        modifiers = ["italic"];
      };
      "variable.other.member" = c.blueLight;
      namespace = c.blue;
      label = c.orange;
      tag = c.orange;
      special = c.orangeLight;

      "markup.heading" = {
        fg = c.orange;
        modifiers = ["bold"];
      };
      "markup.list" = c.orange;
      "markup.bold" = {modifiers = ["bold"];};
      "markup.italic" = {modifiers = ["italic"];};
      "markup.strikethrough" = {modifiers = ["crossed_out"];};
      "markup.link.url" = {
        fg = c.blue;
        modifiers = ["underlined"];
      };
      "markup.link.text" = c.blueLight;
      "markup.quote" = {
        fg = c.gray7;
        modifiers = ["italic"];
      };
      "markup.raw" = c.green;

      "diff.plus" = c.green;
      "diff.minus" = c.red;
      "diff.delta" = c.yellow;

      error = c.red;
      warning = c.yellow;
      info = c.blue;
      hint = c.cyan;
      "diagnostic.error" = {
        underline = {
          color = c.red;
          style = "curl";
        };
      };
      "diagnostic.warning" = {
        underline = {
          color = c.yellow;
          style = "curl";
        };
      };
      "diagnostic.info" = {
        underline = {
          color = c.blue;
          style = "curl";
        };
      };
      "diagnostic.hint" = {
        underline = {
          color = c.cyan;
          style = "curl";
        };
      };
      "diagnostic.unnecessary" = {modifiers = ["dim"];};
      "diagnostic.deprecated" = {modifiers = ["crossed_out"];};
    };
    defaultEditor = false;
    extraPackages = with pkgs; [
      # Nix
      nil
      alejandra

      # JS/TS/HTML/CSS/JSON/Markdown/YAML/Astro
      nodejs_22
      typescript-language-server
      typescript
      biome
      prettier
      vscode-langservers-extracted
      yaml-language-server

      # Python
      pyright
      black

      # C/C++
      clang-tools

      # Rust
      rust-analyzer
      rustfmt

      # Astro
      astro-language-server

      # TOML
      taplo

      # Docker
      dockerfile-language-server
      docker-compose-language-service

      # Tailwind CSS
      tailwindcss-language-server

      # Emmet
      emmet-language-server

      # Shell
      bash-language-server
      shfmt

      # Lua
      lua-language-server
      stylua

      # Markdown
      marksman

      # SQL
      sqls
      sql-formatter

      # Nushell (uses built-in --lsp)
      nushell

      # File manager
      yazi
    ];

    settings = {
      theme = "caelus";

      editor = {
        line-number = "relative";
        cursorline = true;
        mouse = true;
        completion-replace = true;

        whitespace = {
          characters = {
            space = "·";
            nbsp = "⍽";
            nnbsp = "␣";
            tab = "→";
            newline = "⏎";
            tabpad = "·";
          };

          render = {
            space = "all";
            tab = "all";
            nbsp = "all";
            nnbsp = "all";
            newline = "all";
            tabpad = "all";
          };
        };

        search = {
          smart-case = true;
          wrap-around = true;
        };

        indent-guides = {
          render = true;
          character = "│";
        };

        scrolloff = 4;

        soft-wrap = {
          enable = false;
        };

        auto-format = true;

        lsp = {
          display-inlay-hints = true;
          display-messages = true;
        };

        cursor-shape = {
          normal = "block";
          insert = "block";
          select = "block";
        };

        true-color = true;
        color-modes = true;

        end-of-line-diagnostics = "hint";
        inline-diagnostics = {
          cursor-line = "warning";
          other-lines = "disable";
        };

        gutters = ["diagnostics" "diff" "line-numbers" "spacer"];

        statusline = {
          left = ["mode" "spinner" "spacer" "version-control" "spacer" "file-name" "read-only-indicator" "file-modification-indicator"];
          center = [];
          right = ["diagnostics" "workspace-diagnostics" "position" "total-line-numbers" "position-percentage" "file-encoding" "file-type" "register" "selections"];
          separator = "│";
          mode = {
            normal = "NORMAL";
            insert = "INSERT";
            select = "SELECT";
          };
        };

        auto-pairs = true;
      };

      keys = {
        normal = {
          # Yazi file manager integration
          "C-y" = [
            ":sh rm -f /tmp/yazi-chosen"
            ":insert-output yazi '%{buffer_name}' --chooser-file=/tmp/yazi-chosen"
            ":sh printf '\\x1b[?1049h\\x1b[?2004h' > /dev/tty"
            ":open %sh{cat /tmp/yazi-chosen}"
            ":redraw"
          ];
        };

        insert = {
          "C-space" = "completion";
        };
      };
    };

    languages = {
      language-server = {
        nil = {
          command = "nil";
        };

        typescript-language-server = {
          command = "typescript-language-server";
          args = ["--stdio"];
        };

        pyright = {
          command = "pyright-langserver";
          args = ["--stdio"];
        };

        clangd = {
          command = "clangd";
        };

        rust-analyzer = {
          command = "rust-analyzer";
        };

        bash-language-server = {
          command = "bash-language-server";
          args = ["start"];
        };

        vscode-html-language-server = {
          command = "vscode-html-language-server";
          args = ["--stdio"];
          config = {
            html = {
              autoClosingTags = true;
            };
          };
        };

        vscode-css-language-server = {
          command = "vscode-css-language-server";
          args = ["--stdio"];
        };

        vscode-json-language-server = {
          command = "vscode-json-language-server";
          args = ["--stdio"];
        };

        yaml-language-server = {
          command = "yaml-language-server";
          args = ["--stdio"];
        };

        marksman = {
          command = "marksman";
          args = ["server"];
        };

        lua-language-server = {
          command = "lua-language-server";
        };

        sqls = {
          command = "sqls";
        };

        nu-lsp = {
          command = "nu";
          args = ["--lsp"];
        };

        tailwindcss-ls = {
          command = "tailwindcss-language-server";
          args = ["--stdio"];
        };

        astro-ls = {
          command = "astro-ls";
          args = ["--stdio"];
        };

        taplo = {
          command = "taplo";
          args = ["lsp" "stdio"];
        };

        docker-langserver = {
          command = "docker-langserver";
          args = ["--stdio"];
        };

        docker-compose-langserver = {
          command = "docker-compose-langserver";
          args = ["--stdio"];
        };

        emmet-language-server = {
          command = "emmet-language-server";
          args = ["--stdio"];
        };
      };

      language = [
        {
          name = "nix";
          language-servers = ["nil"];
          auto-format = true;
          formatter = {
            command = lib.getExe pkgs.alejandra;
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "typescript";
          language-servers = ["typescript-language-server" "tailwindcss-ls"];
          auto-format = true;
          formatter = {
            command = "biome";
            args = ["format" "--stdin-file-path" "file.ts"];
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "javascript";
          language-servers = ["typescript-language-server" "tailwindcss-ls"];
          auto-format = true;
          formatter = {
            command = "biome";
            args = ["format" "--stdin-file-path" "file.js"];
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "tsx";
          language-servers = ["typescript-language-server" "tailwindcss-ls" "emmet-language-server"];
          auto-format = true;
          formatter = {
            command = "biome";
            args = ["format" "--stdin-file-path" "file.tsx"];
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "jsx";
          language-servers = ["typescript-language-server" "tailwindcss-ls" "emmet-language-server"];
          auto-format = true;
          formatter = {
            command = "biome";
            args = ["format" "--stdin-file-path" "file.jsx"];
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "python";
          language-servers = ["pyright"];
          auto-format = true;
          formatter = {
            command = "black";
            args = ["-"];
          };
          indent = {
            tab-width = 4;
            unit = "    ";
          };
        }

        {
          name = "c";
          language-servers = ["clangd"];
          auto-format = true;
          formatter = {
            command = "clang-format";
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "cpp";
          language-servers = ["clangd"];
          auto-format = true;
          formatter = {
            command = "clang-format";
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "rust";
          language-servers = ["rust-analyzer"];
          auto-format = true;
          formatter = {
            command = "rustfmt";
          };
          indent = {
            tab-width = 4;
            unit = "    ";
          };
        }

        {
          name = "bash";
          language-servers = ["bash-language-server"];
          auto-format = true;
          formatter = {
            command = "shfmt";
            args = ["-i" "2" "-ci" "-sr"];
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "yaml";
          language-servers = ["yaml-language-server"];
          auto-format = true;
          formatter = {
            command = "prettier";
            args = ["--parser" "yaml"];
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "json";
          language-servers = ["vscode-json-language-server"];
          auto-format = true;
          formatter = {
            command = "biome";
            args = ["format" "--stdin-file-path" "file.json"];
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "html";
          language-servers = ["vscode-html-language-server" "emmet-language-server" "tailwindcss-ls"];
          auto-format = true;
          formatter = {
            command = "prettier";
            args = ["--parser" "html"];
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "css";
          language-servers = ["vscode-css-language-server" "tailwindcss-ls"];
          auto-format = true;
          formatter = {
            command = "biome";
            args = ["format" "--stdin-file-path" "file.css"];
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "markdown";
          language-servers = ["marksman"];
          auto-format = true;
          formatter = {
            command = "prettier";
            args = ["--parser" "markdown"];
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "lua";
          language-servers = ["lua-language-server"];
          auto-format = true;
          formatter = {
            command = "stylua";
            args = ["-"];
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "sql";
          language-servers = ["sqls"];
          auto-format = true;
          formatter = {
            command = "sql-formatter";
            args = ["--language" "postgresql"];
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "astro";
          language-servers = ["astro-ls" "tailwindcss-ls" "emmet-language-server"];
          auto-format = true;
          formatter = {
            command = "prettier";
            args = ["--parser" "astro"];
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "toml";
          language-servers = ["taplo"];
          auto-format = true;
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "scss";
          language-servers = ["vscode-css-language-server" "tailwindcss-ls"];
          auto-format = true;
          formatter = {
            command = "prettier";
            args = ["--parser" "scss"];
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "dockerfile";
          language-servers = ["docker-langserver"];
          auto-format = true;
          indent = {
            tab-width = 4;
            unit = "    ";
          };
        }

        {
          name = "docker-compose";
          language-servers = ["docker-compose-langserver" "yaml-language-server"];
          auto-format = true;
          formatter = {
            command = "prettier";
            args = ["--parser" "yaml"];
          };
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }

        {
          name = "nu";
          language-servers = ["nu-lsp"];
          auto-format = false;
          indent = {
            tab-width = 2;
            unit = "  ";
          };
        }
      ];
    };
  };
}
