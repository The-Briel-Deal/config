local dap = require('dap')

-- No more stinky UI.
-- ui.setup()
-- dap.listeners.after.event_initialized["dapui_config"] = function()
-- 	ui.open()
-- end
-- dap.listeners.before.event_terminated["dapui_config"] = function()
-- 	ui.close()
-- end
-- dap.listeners.before.event_exited["dapui_config"] = function()
-- 	ui.close()
-- end

vim.keymap.set('n', '<Leader>db', dap.set_breakpoint)
vim.keymap.set('n', '<Leader>dr', dap.continue)
