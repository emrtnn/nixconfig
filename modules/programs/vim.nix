{pkgs, ...}: {
  programs.nvf = {
    enable = true;

    settings = {
      vim = {
        lineNumberMode = "relNumber";

        searchCase = "smart";

        undoFile.enable = true;
        options = {
          undolevels = 10000;

          tabstop = 2;
          shiftwidth = 2;
          expandtab = true;
          autoindent = true;
          smartindent = true;
          shiftround = true;

          cursorline = true;
          scrolloff = 4;
          sidescrolloff = 8;
          wrap = false;

          termguicolors = true;
          signcolumn = "yes";

          laststatus = 3;
          showmode = false;

          autowrite = true;
          confirm = true;

          splitbelow = true;
          splitright = true;

          updatetime = 200;
          timeoutlen = 300;

          virtualedit = "block";

          guicursor = "i:block-blinkwait0-blinkon400-blinkoff250";
        };

        keymaps = [
          {
            key = "<C-d>";
            mode = "n";
            action = "<C-d>zz";
          }
          {
            key = "<C-u>";
            mode = "n";
            action = "<C-u>zz";
          }
          {
            key = "<leader>e";
            mode = "n";
            action = "<CMD>Oil<CR>";
            desc = "Oil Explorer";
          }
          {
            key = "<ESC>";
            mode = "n";
            action = "<CMD>nohl<CR>";
          }
          {
            key = "<leader>:";
            mode = "n";
            action = "<CMD>Telescope command_history<CR>";
            desc = "Command History";
          }
          {
            key = "[q";
            mode = "n";
            action = "<CMD>lua require('trouble').previous({skip_groups = true, jump = true})<CR>";
            desc = "Previous Trouble/Quickfix Item";
          }
          {
            key = "]q";
            mode = "n";
            action = "<CMD>lua require('trouble').next({skip_groups = true, jump = true})<CR>";
            desc = "Next Trouble/Quickfix Item";
          }
          {
            key = "ih";
            mode = [
              "o"
              "x"
            ];
            action = ":<C-U>Gitsigns select_hunk<CR>";
            desc = "GitSigns Select Hunk";
          }
          {
            key = "<leader>ghB";
            mode = "n";
            action = "<CMD>lua require('gitsigns').blame()<CR>";
            desc = "Blame Buffer";
          }
          {
            key = "]t";
            mode = "n";
            action = ":lua require('todo-comments').jump_next()<CR>";
            desc = "Next Todo Comment";
          }
          {
            key = "[t";
            mode = "n";
            action = ":lua require('todo-comments').jump_prev()<CR>";
            desc = "Previous Todo Comment";
          }
        ];

        theme = {
          enable = true;
          name = "gruvbox";
          style = "dark";
          transparent = false;
        };

        treesitter = {
          enable = true;
          highlight.enable = true;
          indent.enable = true;
          fold = false;
          autotagHtml = true;
          addDefaultGrammars = true;

          textobjects = {
            enable = false;
            setupOpts = {
              move = {
                enable = true;
                set_jumps = true;
                goto_next_start = {
                  "]f" = "@function.outer";
                  "]c" = "@class.outer";
                  "]a" = "@parameter.inner";
                };
                goto_next_end = {
                  "]F" = "@function.outer";
                  "]C" = "@class.outer";
                  "]A" = "@parameter.inner";
                };
                goto_previous_start = {
                  "[f" = "@function.outer";
                  "[c" = "@class.outer";
                  "[a" = "@parameter.inner";
                };
                goto_previous_end = {
                  "[F" = "@function.outer";
                  "[C" = "@class.outer";
                  "[A" = "@parameter.inner";
                };
              };
            };
          };
        };

        diagnostics = {
          enable = true;
          nvim-lint = {
            enable = true;
            lint_after_save = true;
          };
        };

        statusline.lualine = {
          enable = true;
          theme = "gruvbox_dark";
          globalStatus = true;
          componentSeparator = {
            left = "|";
            right = "|";
          };
          sectionSeparator = {
            left = "";
            right = "";
          };

          # --- SECTION A: Mode ---
          activeSection.a = [
            ''{ "mode", icons_enabled = true, separator = { left = "", right = "" }, right_padding = 2 }''
          ];

          # --- SECTION B: Branch ---
          activeSection.b = [
            ''{ "branch", icon = "", separator = { left = "", right = "" } }''
          ];

          # --- SECTION C: Diagnostics & File Info ---
          activeSection.c = [
            ''
              {
                "diagnostics",
                sources = { "nvim_diagnostic" },
                symbols = { error = " ", warn = " ", info = " ", hint = " " },
                colored = true
              }
            ''
            # 2. Filetype Icon (No text, just icon)
            ''{ "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } }''
            # 3. Filename (Relative path)
            ''{ "filename", path = 1, symbols = { modified = "  ", readonly = "  ", unnamed = "" } }''
          ];

          # --- SECTION X: Diff & LSP ---
          activeSection.x = [
            # 1. Diff (Moved to Right)
            ''
              {
                "diff",
                symbols = { added = " ", modified = " ", removed = " " },
                colored = true
              }
            ''
            # 2. LSP Status (Native NVF logic is good, but let's keep it minimal)
            ''
              {
                function()
                  local clients = vim.lsp.get_clients()
                  if next(clients) == nil then return "No LSP" end
                  return clients[1].name
                end,
                icon = " ",
                color = { fg = "#d3869b", gui = "bold" } -- Gruvbox purple-ish
              }
            ''
          ];

          # --- SECTION Y: Progress & Location ---
          activeSection.y = [
            ''{ "progress", separator = " ", padding = { left = 1, right = 0 } }''
            ''{ "location", padding = { left = 0, right = 1 } }''
          ];

          # --- SECTION Z: Time ---
          activeSection.z = [
            ''
              {
                function() return " " .. os.date("%R") end,
                separator = { right = "" },
                left_padding = 2
              }
            ''
          ];
        };

        telescope = {
          enable = true;
          mappings = {
            findFiles = "<leader>ff";
            liveGrep = "<leader>/";
            helpTags = "<leader>fh";
            gitStatus = "<leader>fgs";
            resume = "<leader>fr";
            buffers = "<leader>fb";
          };
          extensions = [
            {
              name = "fzf";
              packages = [pkgs.vimPlugins.telescope-fzf-native-nvim];
              setup = {
                fzf = {
                  fuzzy = true;
                  override_generic_sorter = true;
                  override_file_sorter = true;
                  case_mode = "smart_case";
                };
              };
            }
          ];
          setupOpts = {
            defaults = {
              prompt_prefix = " ";
              selection_caret = " ";
              sorting_strategy = "ascending";
              layout_config = {
                horizontal = {
                  prompt_position = "top";
                  preview_width = 0.55;
                };
                vertical = {
                  mirror = false;
                };
                width = 0.87;
                height = 0.80;
                preview_cutoff = 120;
              };
              path_display = ["truncate"];
            };

            pickers = {
              find_files = {
                hidden = false;
                find_command = [
                  "${pkgs.fd}/bin/fd"
                  "--type"
                  "f"
                  "--strip-cwd-prefix"
                ];
              };
            };
          };
        };

        snippets.luasnip.enable = true;

        autocomplete.nvim-cmp = {
          enable = true;
          sources = {
            nvim_lsp = "[LSP]";
            path = "[Path]";
            luasnip = "[Snip]";
            buffer = "[Buffer]";
          };
          mappings = {
            complete = "<C-Space>";
            confirm = "<CR>";
            next = "<C-n>";
            previous = "<C-p>";
            close = "<C-e>";
            scrollDocsUp = "<C-b>";
            scrollDocsDown = "<C-f>";
          };
          format = {
            _type = "lua-inline";
            expr = ''
              function(entry, item)
                local icons = {
                  Text = "󰉿", Method = "󰆧", Function = "󰊕", Constructor = "",
                  Field = "󰜢", Variable = "󰀫", Class = "󰠱", Interface = "",
                  Module = "", Property = "󰜢", Unit = "󰑭", Value = "󰎠",
                  Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
                  File = "󰈙", Reference = "󰈇", Folder = "󰉋", EnumMember = "",
                  Constant = "󰏿", Struct = "󰙅", Event = "", Operator = "󰆕",
                  TypeParameter = ""
                }

                if icons[item.kind] then
                  item.kind = icons[item.kind] .. " " .. item.kind
                end

                local widths = { abbr = 40, menu = 30 }
                for key, width in pairs(widths) do
                  if item[key] and vim.fn.strdisplaywidth(item[key]) > width then
                    item[key] = vim.fn.strcharpart(item[key], 0, width - 1) .. "…"
                  end
                end

                return item
              end
            '';
          };
          setupOpts = {
            experimental = {
              ghost_text = true;
            };
            completion = {
              completeopt = "menu,menuone,noinsert";
            };
            window = {
              completion = {
                border = "rounded";
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
              };
              documentation = {
                border = "rounded";
                winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None";
              };
            };
          };
        };

        clipboard = {
          enable = true;
          registers = "unnamedplus";
          providers.wl-copy.enable = true;
        };

        lsp = {
          enable = true;
          formatOnSave = true;
          inlayHints.enable = true;
          trouble = {
            enable = true;
            mappings = {
              symbols = "<leader>cs";

              lspReferences = "<leader>cS";
              locList = "<leader>xL";
              quickfix = "<leader>xQ";
              documentDiagnostics = "<leader>xX";
              workspaceDiagnostics = "<leader>xx";
            };
          };
          mappings = {
            codeAction = "<leader>ca";
            goToDefinition = "gd";
            goToDeclaration = "gD";
            goToType = "gt";
            hover = "K";
            signatureHelp = "gK";
            listImplementations = "gi";
            listReferences = "gr";
            renameSymbol = "<leader>cr";
            nextDiagnostic = "]d";
            previousDiagnostic = "[d";
            openDiagnosticFloat = "<leader>cd";
            format = "<leader>cf";
          };
        };

        languages = {
          enableTreesitter = true;
          enableExtraDiagnostics = true;
          enableFormat = true;
          enableDAP = true;

          nix = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };

          ts = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            extraDiagnostics.enable = true;
          };

          nu = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };

          tailwind = {
            enable = true;
            lsp.enable = true;
          };

          yaml = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };

          css = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };

          clang = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            dap.enable = true;
          };

          bash = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };

          astro = {
            enable = true;
            format.enable = true;
            extraDiagnostics.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };

          markdown = {
            enable = true;
            extensions = {
              render-markdown-nvim = {
                enable = true;
              };
            };
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };

          html = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter = {
              enable = true;
              autotagHtml = true;
            };
          };

          python = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
            dap.enable = true;
          };

          qml = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };

          sql = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };

          json = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };

          lua = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            lsp.lazydev.enable = true;
            treesitter.enable = true;
          };
        };

        formatter = {
          conform-nvim = {
            enable = true;
            setupOpts = {
              default_format_opts = {
                timeout_ms = 3000;
                async = false;
                quiet = false;
                lsp_format = "fallback";
              };
            };
          };
        };

        binds = {
          whichKey = {
            enable = true;
            setupOpts = {
              preset = "helix";
            };
          };
        };

        git = {
          gitsigns = {
            enable = true;
            setupOpts = {
              signs = {
                add = {
                  text = "▎";
                };
                change = {
                  text = "▎";
                };
                delete = {
                  text = "";
                };
                topdelete = {
                  text = "";
                };
                changedelete = {
                  text = "▎";
                };
                untracked = {
                  text = "▎";
                };
              };
              signs_staged = {
                add = {
                  text = "▎";
                };
                change = {
                  text = "▎";
                };
                delete = {
                  text = "";
                };
                topdelete = {
                  text = "";
                };
                changedelete = {
                  text = "▎";
                };
              };
            };
            mappings = {
              nextHunk = "]h";
              previousHunk = "[h";
              stageHunk = "<leader>ghs";
              resetHunk = "<leader>ghr";
              stageBuffer = "<leader>ghS";
              undoStageHunk = "<leader>ghu";
              resetBuffer = "<leader>ghR";
              previewHunk = "<leader>ghp";
              blameLine = "<leader>ghb";
              diffThis = "<leader>ghd";
              diffProject = "<leader>ghD";
            };
          };
        };

        debugger = {
          nvim-dap = {
            enable = true;
          };
        };

        mini = {
          ai.enable = true;
          icons.enable = true;
          surround.enable = true;
        };

        autopairs.nvim-autopairs = {
          enable = true;
          setupOpts = {
            disable_filetype = [
              "TelescopePrompt"
              "guihua"
            ];
            disable_in_macro = true;
            ignored_next_char = "[%w%.]";
            enable_check_bracket_line = true;
            check_ts = true;
          };
        };

        comments = {
          comment-nvim = {
            enable = true;
          };
        };

        notes = {
          todo-comments = {
            enable = true;
            mappings = {
              telescope = "<leader>st";
              trouble = "<leader>xt";
            };
          };
        };

        utility = {
          oil-nvim = {
            enable = true;
            gitStatus.enable = true;
            setupOpts = {
              default_file_explorer = true;
              skip_confirm_for_simple_edits = true;
              watch_for_changes = true;
            };
          };
          yanky-nvim = {
            enable = true;
            setupOpts = {
              ring.storage = "sqlite";
            };
          };
          smart-splits = {
            enable = true;

            # 2. Define the keymaps using the native NVF options
            keymaps = {
              move_cursor_left = "<C-h>";
              move_cursor_down = "<C-j>";
              move_cursor_up = "<C-k>";
              move_cursor_right = "<C-l>";

              # Optional: Resize keys (matches the Tmux config below)
              resize_left = "<A-h>";
              resize_down = "<A-j>";
              resize_up = "<A-k>";
              resize_right = "<A-l>";
            };
          };
          snacks-nvim = {
            enable = true;
            setupOpts = {
              indent = {
                enabled = true;
              };
              input = {
                enabled = true;
              };
              notifier = {
                enabled = true;
              };
            };
          };
          motion = {
            flash-nvim = {
              enable = true;
              setupOpts = {
                labels = "asdfghjklqwertyuiopzxcvbnm";
                search = {
                  mode = "fuzzy";
                };
              };
              mappings = {
                jump = "s";
                treesitter = "S";
              };
            };
          };
        };

        ui = {
          borders = {
            enable = true;
            globalStyle = "rounded";
            plugins = {
              nvim-cmp = {
                enable = true;
                style = "rounded";
              };
              which-key = {
                enable = true;
                style = "rounded";
              };
            };
          };

          colorizer = {
            enable = true;
            setupOpts = {
              user_default_options = {
                tailwind = true;
                mode = "background";
              };
            };
          };
        };
        dashboard.alpha = {
          enable = true;
          theme = null;
          layout = [
            {
              type = "padding";
              val = 7;
            }
            {
              type = "text";
              val = [
                "                                                                         "
                "                                                                       "
                "       ████ ██████           █████       ██                      "
                "      ███████████             █████                               "
                "      █████████ ███████████████████ ███   ███████████     "
                "     █████████  ███    █████████████ █████ ██████████████     "
                "    █████████ ██████████ █████████ █████ █████ ████ █████     "
                "  ███████████ ███    ███ █████████ █████ █████ ████ █████    "
                " ██████  █████████████████████ ████ █████ █████ ████ ██████   "
                "                                                                         "
              ];
              opts = {
                hl = "Type";
                position = "center";
              };
            }

            {
              type = "padding";
              val = 2;
            }

            {
              type = "group";
              val = [
                {
                  type = "button";
                  val = "  Find File";
                  on_press = {
                    __raw = "function() require('telescope.builtin').find_files() end";
                  };
                  opts = {
                    shortcut = "f";
                    keymap = [
                      "n"
                      "f"
                      "<cmd>Telescope find_files<CR>"
                      {
                        noremap = true;
                        silent = true;
                        nowait = true;
                      }
                    ];
                    position = "center";
                    hl = "Function";
                    cursor = 3;
                    width = 40;
                    align_shortcut = "right";
                    hl_shortcut = "Keyword";
                  };
                }
                {
                  type = "button";
                  val = "  New File";
                  on_press = {
                    __raw = "function() vim.cmd[[ene]] vim.cmd[[startinsert]] end";
                  };
                  opts = {
                    shortcut = "n";
                    keymap = [
                      "n"
                      "n"
                      "<cmd>ene <BAR> startinsert<CR>"
                      {
                        noremap = true;
                        silent = true;
                        nowait = true;
                      }
                    ];
                    position = "center";
                    hl = "Function";
                    cursor = 3;
                    width = 40;
                    align_shortcut = "right";
                    hl_shortcut = "Keyword";
                  };
                }
                {
                  type = "button";
                  val = "  Recent";
                  on_press = {
                    __raw = "function() require('telescope.builtin').oldfiles() end";
                  };
                  opts = {
                    shortcut = "r";
                    keymap = [
                      "n"
                      "r"
                      "<cmd>Telescope oldfiles<CR>"
                      {
                        noremap = true;
                        silent = true;
                        nowait = true;
                      }
                    ];
                    position = "center";
                    hl = "Function";
                    cursor = 3;
                    width = 40;
                    align_shortcut = "right";
                    hl_shortcut = "Keyword";
                  };
                }
                {
                  type = "button";
                  val = "  Grep";
                  on_press = {
                    __raw = "function() require('telescope.builtin').live_grep() end";
                  };
                  opts = {
                    shortcut = "g";
                    keymap = [
                      "n"
                      "g"
                      "<cmd>Telescope live_grep<CR>"
                      {
                        noremap = true;
                        silent = true;
                        nowait = true;
                      }
                    ];
                    position = "center";
                    hl = "Function";
                    cursor = 3;
                    width = 40;
                    align_shortcut = "right";
                    hl_shortcut = "Keyword";
                  };
                }
                {
                  type = "button";
                  val = "  Quit";
                  on_press = {
                    __raw = "function() vim.cmd[[qa]] end";
                  };
                  opts = {
                    shortcut = "q";
                    keymap = [
                      "n"
                      "q"
                      "<cmd>qa<CR>"
                      {
                        noremap = true;
                        silent = true;
                        nowait = true;
                      }
                    ];
                    position = "center";
                    hl = "Function";
                    cursor = 3;
                    width = 40;
                    align_shortcut = "right";
                    hl_shortcut = "Keyword";
                  };
                }
              ];
            }

            {
              type = "padding";
              val = 2;
            }

            {
              type = "text";
              val = "λ Purely Functional Editing";
              opts = {
                hl = "Comment";
                position = "center";
              };
            }
          ];
        };
      };
    };
  };
}
