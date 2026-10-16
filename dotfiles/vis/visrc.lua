require("vis")

vis.events.subscribe(vis.events.INIT, function()
	vis:command("set theme caelus")
	vis:command("set ignorecase on")
end)

vis.events.subscribe(vis.events.WIN_OPEN, function(win)
	-- From ../nvim/lua/config/options.lua
	vis:command("set tabwidth 2")
	vis:command("set expandtab on")
	vis:command("set autoindent on")
	vis:command("set numbers on")
	vis:command("set relativenumbers on")
	vis:command("set cursorline on")
	vis:command("set showspaces off")
	vis:command("set showtabs off")
end)

vis:map(vis.modes.NORMAL, " y", '"+y')
vis:map(vis.modes.VISUAL, " y", '"+y')
vis:map(vis.modes.NORMAL, " p", '"+p')
vis:map(vis.modes.NORMAL, " P", '"+P')

-- File explorer: yazi as a picker (same as C-y in ../../home/programs/helix.nix).
-- The first chosen file replaces the current window (if it has no unsaved
-- changes), any others open in new windows.
local function shquote(s) return "'" .. s:gsub("'", "'\\''") .. "'" end
local function visquote(s) return "'" .. s:gsub("'", "\\'") .. "'" end

local function explore()
	local chooser = os.tmpname()
	local file = vis.win and vis.win.file
	local start = (file and file.path) or "."
	vis:command(string.format("!yazi %s --chooser-file=%s", shquote(start), shquote(chooser)))
	-- vis:command() reports success even when :e refuses, so check up front.
	local replace = not (file and file.modified)
	for path in io.lines(chooser) do
		if path ~= "" then
			vis:command((replace and "e " or "open ") .. visquote(path))
			replace = false
		end
	end
	os.remove(chooser)
	vis:redraw()
end

vis:command_register("explore", function() explore() return true end, "Pick files with yazi")

local autoclose = require("plugins/vis-autoclose")
local completefilename = require("plugins/complete-filename")

-- LSP: same servers as ../nvim/lua/plugins/lsp.lua (one per vis syntax)
local lsp = require("plugins/vis-lspc")

-- After vis-lspc, which binds <Space>e to diagnostics.
vis:map(vis.modes.NORMAL, " f", explore, "File explorer (yazi)")

local ls = lsp.ls_map

local clangd = {
	name = "clangd",
	cmd = "clangd --background-index --clang-tidy --header-insertion=iwyu --completion-style=detailed --function-arg-placeholders --fallback-style=llvm",
	roots = { "compile_commands.json", ".clangd" },
}
ls.c, ls.cpp, ls.ansi_c = clangd, clangd, clangd

ls.rust = {
	name = "rust-analyzer",
	cmd = "rust-analyzer",
	roots = { "Cargo.toml" },
	settings = {
		["rust-analyzer"] = {
			cargo = { allFeatures = true, loadOutDirsFromCheck = true, buildScripts = { enable = true } },
			procMacro = { enable = true },
			check = { command = "clippy" },
		},
	},
}

ls.zig = { name = "zls", cmd = "zls", roots = { "build.zig", "build.zig.zon" } }
ls.nix = { name = "nixd", cmd = "nixd", roots = { "flake.nix" } }
ls.php = { name = "phpactor", cmd = "phpactor language-server", roots = { "composer.json" } }
ls.cmake = { name = "neocmakelsp", cmd = "neocmakelsp stdio" }
ls.dockerfile = { name = "dockerls", cmd = "docker-langserver --stdio" }
ls.yaml = { name = "yamlls", cmd = "yaml-language-server --stdio" }
ls.json = { name = "jsonls", cmd = "vscode-json-language-server --stdio" }

local vtsls = { name = "vtsls", cmd = "vtsls --stdio", roots = { "tsconfig.json", "jsconfig.json", "package.json" } }
ls.javascript, ls.typescript = vtsls, vtsls

ls.python = {
	name = "basedpyright",
	cmd = "basedpyright-langserver --stdio",
	roots = { "pyproject.toml", "setup.py", "requirements.txt" },
	settings = { basedpyright = { analysis = { typeCheckingMode = "basic" } } },
}

ls.lua = {
	name = "lua-language-server",
	cmd = "lua-language-server",
	settings = { Lua = { diagnostics = { globals = { "vis" } }, telemetry = { enable = false }, hint = { enable = true } } },
}
