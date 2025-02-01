local M = {}

local GDB_INIT_FILE = ".gdbinit"

M.setup = function(_)
	local set = vim.keymap.set

	-- New breakpoint
	set('n', '<leader>bb', function()
		local break_stmt = M.get_break_stmt()

		local file = assert(io.open(GDB_INIT_FILE, "a"))
		assert(file:write(break_stmt))
		assert(file:close())
	end)

	-- Clear all breakpoints
	set('n', '<leader>bc', function()
		local file = assert(io.open(GDB_INIT_FILE, "w"))
		assert(file:write(""))
		assert(file:close())
	end)
end

--- @return string
---
--- Makes a gdb break statement at your cursors current line.
M.get_break_stmt = function()
	local filename = vim.fn.expand("%:p")
	local line_num = vim.fn.line('.')
	local break_stmt = string.format("break %s:%i\n", filename, line_num)

	return break_stmt
end

M.mark_breakpoints = function()
	vim.fn.sign_define("breakpoint", { text = "BP", texthl = "ErrorMsg" })
	local breakpoints = {}

	local file = assert(io.open(GDB_INIT_FILE, "r"))

	for line in file:lines() do
		local length = string.len(line)
		local _, j = assert(string.find(line, "break "))
		local name_and_line = string.sub(line, j + 1, length)

		length = string.len(name_and_line)
		local split_index, _ = assert(string.find(name_and_line, ":"))

		local name = string.sub(name_and_line, 1, split_index - 1)
		local line_num = string.sub(name_and_line, split_index + 1, length)
		-- print("Name: '" .. name .. "' Line Num: '" .. line_num .. "'")
		breakpoints[#breakpoints + 1] = { name = name, line = line_num }
	end

	for i, breakpoint in pairs(breakpoints) do
		-- print(i .. " -- Name: '" .. breakpoint.name .. "' Line Num: '" .. breakpoint.line .. "'")
		vim.fn.sign_place(i, "breakpoints", "breakpoint", breakpoint.name, {lnum=breakpoint.line})
	end

	assert(file:close())
end

return M
