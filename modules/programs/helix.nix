{
  pkgs,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;
    defaultEditor = true;
    extraPackages = with pkgs; [
      # Nix
      nil
      alejandra

      # JS/TS/HTML/CSS/JSON/Markdown/YAML/Astro
      nodejs_22
      nodePackages.typescript-language-server
      nodePackages.typescript
      biome
      nodePackages.prettier
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server

      # Python
      pyright
      black

      # C/C++
      clang-tools

      # Rust
      rust-analyzer
      rustfmt

      # Shell
      nodePackages.bash-language-server
      shfmt

      # Lua
      lua-language-server
      stylua

      # Markdown
      marksman

      # SQL
      sqls
      nodePackages.sql-formatter

      # Nushell (uses built-in --lsp)
      nushell

      # File manager
      yazi
    ];

    settings = {
      theme = "gruvbox";

      editor = {
        line-number = "relative";
        cursorline = true;
        mouse = false;

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
          left = ["mode" "spinner" "file-name" "file-modification-indicator"];
          center = ["diagnostics"];
          right = ["selections" "position" "file-encoding" "file-type"];
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
          language-servers = ["typescript-language-server"];
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
          language-servers = ["typescript-language-server"];
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
          language-servers = ["typescript-language-server"];
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
          language-servers = ["typescript-language-server"];
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
          language-servers = ["vscode-html-language-server"];
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
