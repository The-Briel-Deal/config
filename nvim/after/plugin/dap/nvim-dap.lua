local dap = require('dap')
local virt_text = require('nvim-dap-virtual-text')

virt_text.setup({})

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

vim.keymap.set('n', '<Leader>db', dap.toggle_breakpoint)
vim.keymap.set('n', '<Leader>dx', dap.clear_breakpoints)
vim.keymap.set('n', '<Leader>dr', dap.continue)
vim.keymap.set('n', '<Leader>dt', dap.repl.toggle)
vim.keymap.set('n', '<Leader>dn', dap.step_over)
vim.keymap.set('n', '<Leader>dk', require('dap.ui.widgets').hover)
vim.keymap.set('n', '<Leader>dc', dap.terminate)
