local ts = require('telescope')
local builtin = require('telescope.builtin')
local ts_utils = require('telescope.utils')


local function find_parent_files()
	local depth_back = vim.fn.input("Parents Dirs Back >")
	local path_to_search = ts_utils.buffer_dir()
	for _ = 1, depth_back, 1 do
		path_to_search = path_to_search .. '/..'
	end
	path_to_search = path_to_search .. '/'
	print(path_to_search)
	builtin.find_files({ cwd = path_to_search })
end

-- Find Files in Vim CWD
vim.keymap.set('n', '<leader>ff', builtin.find_files)

-- (Uninstalled as I wasn't using this) Find Files in Vim CWD
-- vim.keymap.set('n', '<leader>fe', ts.extensions.file_browser.file_browser)

-- Find Files Not Ignored By Git
vim.keymap.set('n', '<leader>fg', builtin.git_files)

-- Find Files Matching a Grep String for Contents
vim.keymap.set('n', '<leader>fs', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

-- Find Files n Dirs Deep From Curr Buffer
vim.keymap.set('n', '<leader>fp', find_parent_files)

-- Find Help Docs
vim.keymap.set('n', '<leader>fh', builtin.help_tags)

-- Find Files in My Config
vim.keymap.set('n', '<leader>fc', function()
	builtin.find_files({ cwd = '~/.config' })
end)

-- Find Files in My Notes
vim.keymap.set('n', '<leader>fn', function()
	builtin.find_files({ cwd = '~/Notes' })
end)

-- Find Files in My Code dir
vim.keymap.set('n', '<leader>fC', function()
	builtin.find_files({ cwd = '~/Code' })
end)

-- Search for a line in curr buffer
vim.keymap.set('n', '<leader>f/', builtin.current_buffer_fuzzy_find)

-- Choose one of my favorite Directories
vim.keymap.set('n', '<leader>fo', builtin.oldfiles)

-- Telescope Buffers
vim.keymap.set('n', '<leader>fb', builtin.buffers)
