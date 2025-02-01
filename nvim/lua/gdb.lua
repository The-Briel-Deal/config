local M = {}

local GDB_INIT_FILE = ".gdbinit"

local function add_breakpoint(breakpoint, filename)
	local file = assert(io.open(filename, "a"))
	assert(file:write(breakpoint))
	assert(file:close())
end

local function remove_breakpoint(breakpoint, filename)
	local file = assert(io.open(filename, "r"))
	local file_content = assert(file:read("a"))
	local new_file_content = string.gsub(file_content, breakpoint, "")
	print("Old file: '" .. file_content .. "',\nNew file: '" .. new_file_content .. "'")
	assert(file:close())

	file = assert(io.open(filename, "w"))
	file:write(new_file_content)
	assert(file:close())
end

local function already_contains_breakpoint(breakpoint, filename)
	local file = assert(io.open(filename, "r"))
	for line in file:lines() do
		-- print("Line: '" .. line .. "', Breakpoint: '" .. breakpoint .. "'")
		if (line .. "\n") == breakpoint then
			assert(file:close())
			return true
		end
	end
	assert(file:close())
	return false
end



M.setup = function(_)
	M.mark_breakpoints()
	local set = vim.keymap.set

	-- New breakpoint
	set('n', '<leader>bb', function()
		local break_stmt = M.get_break_stmt()
		if already_contains_breakpoint(break_stmt, GDB_INIT_FILE) then
			remove_breakpoint(break_stmt, GDB_INIT_FILE)
		else
			add_breakpoint(break_stmt, GDB_INIT_FILE)
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
		vim.fn.sign_place(i, "breakpoints", "breakpoint", breakpoint.name, { lnum = breakpoint.line })
	end

	assert(file:close())
end

return M
