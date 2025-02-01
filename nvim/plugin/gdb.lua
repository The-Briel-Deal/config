local set = vim.keymap.set
set('n', '<leader>db', function()
	local filename = vim.fn.expand("%:t")
	local line_num = vim.fn.line('.')
	local break_stmt = string.format("break %s:%i\n", filename, line_num)

	local file = assert(io.open(".gdbinit", "a"))

	assert(file:write(break_stmt))
	assert(file:close())

end)
