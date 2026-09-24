return {
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		build = ":TSUpdate",
		lazy = false,
		config = function()
			local treesitter = require("nvim-treesitter")
			local parsers = {
				"astro",
				"bash",
				"c",
				"cpp",
				"css",
				"cmake",
				"diff",
				"dockerfile",
				"html",
				"javascript",
				"jsdoc",
				"json",
				"lua",
				"luadoc",
				"luap",
				"markdown",
				"markdown_inline",
				"nix",
				"python",
				"query",
				"regex",
				"rust",
				"solidity",
				"toml",
				"typescript",
				"tsx",
				"vim",
				"vimdoc",
				"xml",
				"yaml",
				"zig",
			}

			local function enable(buf)
				local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
				if not lang or not vim.treesitter.language.add(lang) then
					return
				end

				vim.treesitter.start(buf, lang)
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo.foldmethod = "expr"
				vim.wo.foldlevel = 99
			end

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(event)
					enable(event.buf)
				end,
			})

			treesitter.install(parsers):await(function()
				vim.schedule(function()
					for _, win in ipairs(vim.api.nvim_list_wins()) do
						vim.api.nvim_win_call(win, function()
							enable(vim.api.nvim_win_get_buf(win))
						end)
					end
				end)
			end)
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		init = function()
			vim.g.no_plugin_maps = true
		end,
		config = function()
			-- 1. Setup the behaviors
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
				},
				move = {
					enable = true,
					set_jumps = true,
				},
			})

			-- Select
			local select = require("nvim-treesitter-textobjects.select")
			local map = vim.keymap.set

			map({ "x", "o" }, "af", function()
				select.select_textobject("@function.outer", "textobjects")
			end, { desc = "Select outer function" })

			map({ "x", "o" }, "if", function()
				select.select_textobject("@function.inner", "textobjects")
			end, { desc = "Select inner function" })

			map({ "x", "o" }, "ac", function()
				select.select_textobject("@class.outer", "textobjects")
			end, { desc = "Select outer class" })

			map({ "x", "o" }, "ic", function()
				select.select_textobject("@class.inner", "textobjects")
			end, { desc = "Select inner class" })

			map({ "x", "o" }, "as", function()
				select.select_textobject("@local.scope", "locals")
			end, { desc = "Select language scope" })

			-- Move
			local move = require("nvim-treesitter-textobjects.move")

			map({ "n", "x", "o" }, "]f", function()
				move.goto_next_start("@function.outer")
			end, { desc = "Next function start" })

			map({ "n", "x", "o" }, "[f", function()
				move.goto_previous_start("@function.outer")
			end, { desc = "Previous function start" })

			map({ "n", "x", "o" }, "]F", function()
				move.goto_next_end("@function.outer")
			end, { desc = "Next function end" })

			map({ "n", "x", "o" }, "[F", function()
				move.goto_previous_end("@function.outer")
			end, { desc = "Previous function end" })

			map({ "n", "x", "o" }, "]C", function()
				move.goto_next_end("@class.outer")
			end, { desc = "Next class end" })

			map({ "n", "x", "o" }, "[C", function()
				move.goto_previous_end("@class.outer")
			end, { desc = "Previous class end" })
		end,
	},
}
