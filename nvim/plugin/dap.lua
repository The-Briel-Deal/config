local dap = require('dap') ---@module 'nvim-dap.lua.dap'

dap.defaults.fallback.external_terminal = {
	command = 'tmux',
	args = { 'splitw' }
}

dap.adapters.gdb = {
	type = 'executable',
	command = 'gdb',
	args = { '--interpreter=dap', '--eval-command', 'set print pretty on' }
}

dap.adapters.lldb = {
	type = 'executable',
	command = '/usr/bin/lldb-dap',
	name = 'lldb',
	args = {},
}


dap.configurations.c = {
	{
		name = 'Launch',
		type = 'lldb',
		request = 'launch',
		program = function()
			return vim.fn.input('Path to executable:', vim.fn.getcwd() .. '/', 'file')
		end,
		runInTerminal = true,
	},
	{
		name = 'Launch nvim headless',
		type = 'lldb',
		request = 'launch',
		program = function()
			return vim.fn.getcwd() .. '/build/bin/nvim'
		end,
		args = { '--headless', '--listen', 'localhost:12345' },
	},
	{
		name = 'Attach to gdb-server',
		type = 'lldb',
		request = 'attach',
		program = function()
			return vim.fn.input('Path to executable:', vim.fn.getcwd() .. '/', 'file')
		end,
		['gdb-remote-port'] = 7777,
	},
}


local function session_active()
	if dap.session() then
		return true
	end
	print('No nvim-dap session active.')
	return false
end

local dap_widgets = require('dap.ui.widgets')
local set = vim.keymap.set

set('n', '<leader>dc', function()
	dap.continue()
end)

set('n', '<leader>dC', function()
	if session_active() then
		dap.run_to_cursor()
	end
end)

set('n', '<leader>dh', function()
	if session_active() then
		dap_widgets.hover()
	end
end)

set('n', '<leader>dk', function()
	if session_active() then
		dap.up()
	end
end)

set('n', '<leader>dj', function()
	if session_active() then
		dap.down()
	end
end)

set('n', '<leader>dn', function()
	if session_active() then
		dap.step_over()
	end
end)

set('n', '<leader>bb', function()
	dap.toggle_breakpoint()
end)

set('n', '<leader>bc', function()
	dap.clear_breakpoints()
end)
