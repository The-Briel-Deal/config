local ui = require('dapui')
local dap = require('dap')

ui.setup()

-- local cpp_dbg_adapter = vim.fn.exepath("OpenDebugAD7")
-- if cpp_dbg_adapter ~= "" then
-- 	dap.adapters.debug_hyprland = {
-- 		type = "executable",
-- 		command = cpp_dbg_adapter,
-- 	}
-- 
-- 	dap.configurations.cpp = {
-- 		{
-- 			type = 'debug_hyprland',
-- 			request = 'launch',
-- 			name = "Launch file",
-- 			projectDir = "${workspaceFolder}",
-- 			exitAfterTaskReturns = false,
-- 			debugAutoInterpretAllModules = false,
-- 		},
-- 	}
-- end

dap.adapters.cppdbg = {
	name = 'cppdbg',
	type = 'executable',
	command = vim.fn.stdpath('data') .. '/mason/bin/OpenDebugAD7',
}
dap.configurations.cpp = {
	{
		name = "Launch",
		type = "cppdbg",
		request = "launch",
		program = function()
			return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
		end,
		cwd = '${workspaceFolder}',
		stopOnEntry = false,
		args = {},
		runInTerminal = true,
	},
}
dap.configurations.h = dap.configurations.cpp
