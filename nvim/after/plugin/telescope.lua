local builtin = require('telescope.builtin')
local ts_utils = require('telescope.utils')

-- Find Files in Vim CWD
vim.keymap.set('n', '<leader>ff', builtin.find_files)
-- Find Files Not Ignored By Git
vim.keymap.set('n', '<leader>fg', builtin.git_files)
-- Find Files Matching a Grep String for Contents 
vim.keymap.set('n', '<leader>fs', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
-- Find Files n Dirs Deep From Curr Buffer
vim.keymap.set('n', '<leader>fp', function()
	local depth_back = vim.fn.input("Parents Dirs Back >")
	local path_to_search = ts_utils.buffer_dir()
	for _ = 1, depth_back, 1 do
		path_to_search = path_to_search .. '/..'
	end
	path_to_search = path_to_search .. '/'
	print(path_to_search)
	builtin.find_files({ cwd = path_to_search })
end
)
-- Find Files in Home
vim.keymap.set('n', '<leader>fh', function()
	builtin.find_files({ cwd = '~' })
end
)
