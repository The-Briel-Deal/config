local M = {}

M.setup = function(_)
	local set = vim.keymap.set

	-- New breakpoint
	set('n', '<leader>bb', function()
		local break_stmt = M.get_break_stmt()

		local file = assert(io.open(".gdbinit", "a"))
		assert(file:write(break_stmt))
		assert(file:close())
	end)

	-- Clear all breakpoints
	set('n', '<leader>bc', function()
		local file = assert(io.open(".gdbinit", "a"))
		assert(file:write(""))
		assert(file:close())
	end)
end

--- @return string
---
--- Makes a gdb break statement at your cursors current line.
M.get_break_stmt = function()
	local filename = vim.fn.expand("%:t")
	local line_num = vim.fn.line('.')
	local break_stmt = string.format("break %s:%i\n", filename, line_num)

	return break_stmt
end

return M
