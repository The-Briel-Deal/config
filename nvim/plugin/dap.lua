local dap = require('dap') ---@module 'nvim-dap.lua.dap'

dap.defaults.fallback.external_terminal = {
	command = 'tmux',
	args = {'splitw'}
}
dap.defaults.fallback.force_external_terminal = true

dap.adapters.gdb = {
	type = 'executable',
	command = 'gdb',
	args = { '--interpreter=dap', '--eval-command', 'set print pretty on' }
}

local lldb_adapter = {
	type = 'executable',
	command = '/usr/bin/lldb-dap',
	name = 'lldb',
	args = {},
}
dap.adapters.lldb = lldb_adapter

local launch_nvim_headless_conf = {
	name = 'Launch nvim headless',
	type = 'lldb',
	request = 'launch',
	program = function()
		return vim.fn.getcwd() .. '/build/bin/nvim'
	end,
	args = { '--headless', '--listen', 'localhost:12345' }
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
	launch_nvim_headless_conf,
}

dap.adapters.python = function(cb, config)
	if config.request == 'attach' then
		---@diagnostic disable-next-line: undefined-field
		local port = (config.connect or config).port
		---@diagnostic disable-next-line: undefined-field
		local host = (config.connect or config).host or '127.0.0.1'
		cb({
			type = 'server',
			port = assert(port, '`connect.port` is required for a python `attach` configuration'),
			host = host,
			options = {
				source_filetype = 'python',
			},
		})
	else
		cb({
			type = 'executable',
			command = 'python',
			args = { '-m', 'debugpy.adapter' },
			options = {
				source_filetype = 'python',
			},
		})
	end
end

dap.configurations.python = {
	{
		-- The first three options are required by nvim-dap
		type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
		request = 'launch',
		name = "Launch file",

		-- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

		program = "psteal", -- This configuration will launch the current file if used.
		pythonPath = function()
			-- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
			-- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
			-- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
			local cwd = vim.fn.getcwd()
			if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
				return cwd .. '/venv/bin/python'
			elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
				return cwd .. '/.venv/bin/python'
			else
				return '/usr/bin/python'
			end
		end,
	},
}

local dap_widgets = require('dap.ui.widgets')

local set = vim.keymap.set

local function session_active()
	if dap.session() then
		return true
	end
	print('No nvim-dap session active.')
	return false
end

set('n', '<leader>drn', function()
	dap.run(launch_nvim_headless_conf)
	local suc, exitcode, code = os.execute('tmux splitw -b nvim --remote-ui --server localhost:12345')
	print("suc: " .. tostring(suc) .. " exitcode: " .. tostring(exitcode) .. " code: " .. tostring(code))
end)

set('n', '<leader>dc', function()
	dap.continue()
end)

set('n', '<leader>dk', function()
	if session_active() then
		dap_widgets.hover()
	end
end)

set('n', '<leader>dC', function()
	if session_active() then
		dap.run_to_cursor()
	end
end)

set('n', '<leader>bb', function()
	dap.toggle_breakpoint()
end)

set('n', '<leader>bc', function()
	dap.clear_breakpoints()
end)
