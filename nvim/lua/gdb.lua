local M = {}

local GDB_INIT_FILE = ".gdbinit"




M.setup = function(_)
	M.mark_breakpoints()
	local set = vim.keymap.set

	-- New breakpoint
	set('n', '<leader>bb', function()
		local break_stmt = M.get_break_stmt()
		if M.already_contains_breakpoint(break_stmt, GDB_INIT_FILE) then
			M.remove_breakpoint(break_stmt, GDB_INIT_FILE)
		else
			M.add_breakpoint(break_stmt, GDB_INIT_FILE)
		end

		M.mark_breakpoints()
	end)

	-- Clear all breakpoints
	set('n', '<leader>bc', function()
		local file = assert(io.open(GDB_INIT_FILE, "w"))
		assert(file:write(""))
		assert(file:close())

		M.mark_breakpoints()
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
	vim.fn.sign_unplace("breakpoints")
	vim.fn.sign_define("breakpoint", { text = "BP", texthl = "ErrorMsg" })
	local breakpoints = {}

	local file = io.open(GDB_INIT_FILE, "r")
	if file == nil then return end

	for line in file:lines() do
		local length = string.len(line)
		local _, j = assert(string.find(line, "break "))
		local name_and_line = string.sub(line, j + 1, length)

		length = string.len(name_and_line)
		local split_index, _ = assert(string.find(name_and_line, ":"))

		local name = string.sub(name_and_line, 1, split_index - 1)
		local line_num = string.sub(name_and_line, split_index + 1, length)
		breakpoints[#breakpoints + 1] = { name = name, line = line_num }
	end

	for i, breakpoint in pairs(breakpoints) do
		vim.fn.sign_place(i, "breakpoints", "breakpoint", breakpoint.name, { lnum = breakpoint.line })
	end

	assert(file:close())
end

M.add_breakpoint = function(breakpoint, filename)
	local file = assert(io.open(filename, "a"))
	assert(file:write(breakpoint))
	assert(file:close())
end

M.remove_breakpoint = function(breakpoint, filename)
	local file = assert(io.open(filename, "r"))
	local file_content = assert(file:read("a"))
	local i, j = assert(string.find(file_content, breakpoint, 1, true))
	assert(file:close())

	local start_content = string.sub(file_content, 1, i - 1)
	local end_content = string.sub(file_content, j + 1, -1)

	file = assert(io.open(filename, "w"))
	file:write(start_content .. end_content)
	assert(file:close())
end

M.already_contains_breakpoint = function(breakpoint, filename)
	local file = assert(io.open(filename, "r"))
	for line in file:lines() do
		if (line .. "\n") == breakpoint then
			assert(file:close())
			return true
		end
	end
	assert(file:close())
	return false
end

return M
