-- KEYBINDS --
-- Set Leader Key as Spacebar.
vim.g.mapleader = " "

-- Set Lead+pv as go to Netrw.
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- Set Lead+bp as go to last Buffer.
vim.keymap.set("n", "<leader>bp", vim.cmd.bp)
-- Set Lead+bn as go to last Buffer.
vim.keymap.set("n", "<leader>bn", vim.cmd.bN)

-- Set go Lead+rf as run file.
vim.keymap.set("n", "<leader>rf", function()
	filetype = vim.bo.filetype
	print(string.format("Building and Running %s File.", filetype))
	-- Handle C
	if filetype=="c" then
		vim.cmd("!gcc %:p -o %:p:r")
		vim.cmd("!%:p:r")
	else
		print(string.format("There is no handler for %s files, you can add it in 'nvim/lua/gfconf/remap.lua'", filetype))
	end
end)
