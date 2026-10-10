return {
	{
		"mfussenegger/nvim-dap",
		dependencies = { "rcarriga/nvim-dap-ui", "theHamsta/nvim-dap-virtual-text" },
		keys = {
			{ "<leader>db", "<cmd>DapToggleBreakpoint<cr>", desc = "Toggle Breakpoint" },
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Breakpoint Condition",
			},
			{ "<leader>dc", "<cmd>DapContinue<cr>", desc = "Run/Continue" },
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
			},
			{ "<leader>di", "<cmd>DapStepInto<cr>", desc = "Step Into" },
			{ "<leader>dO", "<cmd>DapStepOver<cr>", desc = "Step Over" },
			{ "<leader>do", "<cmd>DapStepOut<cr>", desc = "Step Out" },
			{
				"<leader>dk",
				function()
					require("dap").up()
				end,
				desc = "Up the Stack",
			},
			{
				"<leader>dj",
				function()
					require("dap").down()
				end,
				desc = "Down the Stack",
			},
			{ "<leader>dP", "<cmd>DapPause<cr>", desc = "Pause" },
			{ "<leader>dt", "<cmd>DapTerminate<cr>", desc = "Terminate" },
			{
				"<leader>du",
				function()
					require("dapui").toggle()
				end,
				desc = "Toggle Debug UI",
			},
			{
				"<leader>de",
				function()
					require("dapui").eval()
				end,
				mode = { "n", "x" },
				desc = "Eval Expression",
			},
		},
		config = function()
			local dap = require("dap")

			-- GDB 14+ speaks the Debug Adapter Protocol natively
			dap.adapters.gdb = {
				type = "executable",
				command = "gdb",
				args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
			}

			local function pick_executable()
				return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
			end

			dap.configurations.c = {
				{
					name = "Launch",
					type = "gdb",
					request = "launch",
					program = pick_executable,
					args = {},
					cwd = "${workspaceFolder}",
					stopAtBeginningOfMainSubprogram = false,
				},
				{
					name = "Attach to process",
					type = "gdb",
					request = "attach",
					pid = function()
						local name = vim.fn.input("Executable name (filter): ")
						return require("dap.utils").pick_process({ filter = name })
					end,
					cwd = "${workspaceFolder}",
				},
				{
					-- For programs that read stdin: run `gdbserver :1234 ./program` in another pane
					name = "Attach to gdbserver :1234",
					type = "gdb",
					request = "attach",
					target = "localhost:1234",
					program = pick_executable,
					cwd = "${workspaceFolder}",
				},
			}
			dap.configurations.cpp = dap.configurations.c

			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "DiagnosticWarn" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DiagnosticError" })
			vim.fn.sign_define("DapLogPoint", { text = "◆", texthl = "DiagnosticInfo" })
			vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticWarn", linehl = "Visual" })
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		lazy = true,
		dependencies = { "nvim-neotest/nvim-nio" },
		config = function()
			local dap, dapui = require("dap"), require("dapui")
			dapui.setup()

			-- Open the UI when a debug session starts and close it when it ends
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end
		end,
	},
	{
		-- Show variable values inline while stepping
		"theHamsta/nvim-dap-virtual-text",
		lazy = true,
		opts = {},
	},
}
