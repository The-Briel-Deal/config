-- Debug Adapter Protocol
---@type LazySpec
return {
	"mfussenegger/nvim-dap",
	dependencies = { "TheHamsta/nvim-dap-virtual-text" },
	config = function()
		local dap = require('dap')

		dap.adapters.gdb = {
			type = "executable",
			command = "gdb",
			args = { "-i", "dap" }
		}

		dap.configurations.cpp = {
			{
				name = "Launch",
				type = "gdb",
				request = "launch",
				program = function()
					local cwd = vim.fn.getcwd()
					if cwd == "/home/gabe/Code/gfwl" then
						return "/home/gabe/Code/gfwl/build/src/gfwl"
					end
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
				cwd = "${workspaceFolder}",
				stopAtBeginningOfMainSubprogram = false,
			}
		}

		vim.keymap.set('n', '<Leader>dc', dap.terminate)
	end,
	keys = {
		{ '<Leader>db', function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
		{ '<Leader>dx', function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoint" },
		{ '<Leader>dr', function() require("dap").continue() end,          desc = "Continue" },
		{ '<Leader>dn', function() require("dap").step_over() end,         desc = "Step Over" },
		{ '<Leader>dk', function() require('dap.ui.widgets').hover() end,  desc = "Hover" },
		{ '<Leader>dc', function() require('dap').terminate() end,         desc = "Terminate" },
	}
}
