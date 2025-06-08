local dap = require('dap') ---@module 'nvim-dap.lua.dap'
local assert = require('luassert')

dap.defaults.fallback.external_terminal = {
	command = 'tmux',
	args = { 'splitw' }
}

dap.adapters.cppdbg = {
	id = 'cppdbg',
	type = 'executable',
	command = os.getenv("HOME") .. '/.local/share/debug_adapters/extension/debugAdapters/bin/OpenDebugAD7',
}

dap.configurations.c = {
	{
		name = 'generic - Launch',
		type = 'cppdbg',
		request = 'launch',
		program = function()
			return vim.fn.input('Path to executable:', vim.fn.getcwd() .. '/', 'file')
		end,
		externalConsole = true,
	},
	{
		name = 'generic - Attach to gdb-server',
		type = 'cppdbg',
		request = 'launch',
		program = function()
			return vim.fn.input('Path to executable:', vim.fn.getcwd() .. '/', 'file')
		end,
		miDebuggerServerAddress = 'localhost:7777',
		cwd = vim.fn.getcwd()
	},
	setmetatable({
			name = 'nvim - Launch Full, Debug Server',
			type = 'cppdbg',
			request = 'launch',
			program = function()
				return vim.fn.getcwd() .. '/build/bin/nvim'
			end,
			externalConsole = true,
			cwd = '.'
		},
		{
			__call = function(config)
				local key = 'gf_nvim_launch_full_debug_server'
				dap.listeners.after.initialize[key] = function(session)
					dap.listeners.after.initialize[key] = nil
					session.on_close[key] = function()
						for _, handler in pairs(dap.listeners.after) do
							handler[key] = nil
						end
					end
				end

				dap.listeners.after.event_process[key] = function(_, body)
					dap.listeners.after.event_process[key] = nil

					local ppid = body.systemProcessId

					vim.wait(1000, function()
						return tonumber(vim.fn.system("ps -o pid= --ppid " .. tostring(ppid))) ~= nil
					end)
					local pid = tonumber(vim.fn.system("ps -o pid= --ppid " .. tostring(ppid)))
					assert(pid ~= nil, "child process ID should not be nil")

					if pid then
						dap.run({
							name = "Neovim embedded",
							type = "cppdbg",
							request = "attach",
							processId = pid,
							program = vim.fn.getcwd() .. "/build/bin/nvim",
							cwd = vim.fn.getcwd(),
							externalConsole = true,
						})
					end
				end
				return config
			end
		}),
	{
		name = 'nvim - Launch Headless',
		type = 'cppdbg',
		request = 'launch',
		program = function()
			return vim.fn.getcwd() .. '/build/bin/nvim'
		end,
		args = { '--headless', '--listen', 'localhost:7777' },
		externalConsole = true,
		cwd = vim.fn.getcwd()
	},
	{
		name = 'nvim - Attach Tests',
		type = 'cppdbg',
		request = 'launch',
		program = function()
			return vim.fn.getcwd() .. '/build/bin/nvim'
		end,
		miDebuggerServerAddress = 'localhost:7777',
		cwd = vim.fn.getcwd()
	},
}


local function session_active()
	local session = dap.session()
	if session and not session.closed then
		return session
	end
	print('No nvim-dap session active.')
	return nil
end

local set = vim.keymap.set

set('n', '<leader>dc', function()
	dap.continue()
end)

set('n', '<leader>dC', function()
	if session_active() then
		dap.run_to_cursor()
	end
end)

set({ 'n', 'v' }, '<C-k>', function()
	local session = session_active()
	if session then
		local expr_under_cursor = vim.fn.expand('<cexpr>')
		session:evaluate({ expression = expr_under_cursor, context = 'hover' }, function(err, res)
			if err then
				print('DAP - Could not evaluate \'' ..
					expr_under_cursor .. (err.body.error and ('\': \'' .. err.body.error .. '\'') or '\'.'))
				return
			end

			assert.not_nil(res)

			local buf = vim.api.nvim_create_buf(false, false)
			local ns = vim.api.nvim_create_namespace('dbg_float')

			local cur_line = 0

			local header = (res.type or '') .. ' ' .. expr_under_cursor
			if type(header) == 'string' then
				local end_col = #header
				vim.api.nvim_buf_set_lines(buf, cur_line, cur_line, true, { header })
				vim.api.nvim_buf_set_extmark(buf, ns, cur_line, 0, { end_col = end_col, end_line = cur_line, hl_group = 'Title' })
				cur_line = cur_line + 1

				vim.api.nvim_buf_set_lines(buf, cur_line, cur_line, true, { "" })
				cur_line = cur_line + 1
			end

			for line in string.gmatch(res.result, '[^\n^\r]*') do
				local end_col = #line
				vim.api.nvim_buf_set_lines(buf, cur_line, cur_line, true, { line })
				vim.api.nvim_buf_set_extmark(buf, ns, cur_line, 0, { end_col = end_col, end_line = cur_line, hl_group = 'NormalFloat' })
				cur_line = cur_line + 1
			end

			--			vim.api.nvim_buf_set_lines(buf, 0, -1, true, contents)
			local win = vim.api.nvim_open_win(buf, false,
				{
					relative = 'cursor',
					border = 'rounded',
					row = 2,
					col = 2,
					width = 40,
					height = 10,
					style = 'minimal',
					title = 'DBG - ' .. expr_under_cursor,
				})
			vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
				callback = function()
					vim.api.nvim_win_close(win, false)
				end,
				once = true,
			})
		end)
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

--- Dap View
local dap_view = require("dap-view")

dap_view.setup({
	winbar = {
		sections = { "watches", "scopes", "exceptions", "breakpoints", "threads", "repl", "console" },
	},
	switchbuf = "uselast,useopen",
})

set('n', '<leader>dv', function()
	dap_view.toggle()
end)
