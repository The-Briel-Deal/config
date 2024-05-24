-- KEYBINDS --
-- Set Leader Key as Spacebar.
vim.g.mapleader = " "

-- Set Lead+pv as go to Netrw.
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- Set Lead+bp as go to last Buffer.
vim.keymap.set("n", "<leader>bp", vim.cmd.bp)
-- Set Lead+bn as go to last Buffer.
vim.keymap.set("n", "<leader>bn", vim.cmd.bN)
-- Set lead-s to quick-save.
vim.keymap.set("n", "<leader>s", vim.cmd.w)
-- Set lead-S to quick-save and close window.
vim.keymap.set("n", "<leader>S", vim.cmd.wq)
-- Set lead-gh as the command to go home in netrw.
vim.keymap.set("n", "<leader>gh", function() vim.cmd("Vexplore ~/") end)
-- Set lead-c as the command to close current split.
vim.keymap.set("n", "<leader>c", vim.cmd.close)
-- Use lead to move between windows.
vim.keymap.set("n", "<leader>h", function() vim.cmd.wincmd("h") end)
vim.keymap.set("n", "<leader>j", function() vim.cmd.wincmd("j") end)
vim.keymap.set("n", "<leader>k", function() vim.cmd.wincmd("k") end)
vim.keymap.set("n", "<leader>l", function() vim.cmd.wincmd("l") end)

-- Open new Daily Note.
vim.keymap.set("n", "<leader>nd", function()
	local template_path = "~/Notes/Templates/nvim-daily-note.md"
	local daily_note_path = '~/Notes/Daily/' .. vim.fn.strftime('%Y-%m-%d') .. '.md'
	if (vim.fn.empty(vim.fn.glob(vim.fn.expand(daily_note_path))) == 1) then
		os.execute("cp " .. template_path .. " " .. daily_note_path)
	end
	vim.cmd.edit(daily_note_path)
end)
