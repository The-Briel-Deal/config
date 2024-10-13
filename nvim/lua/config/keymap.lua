-- KEYBINDS --
-- Set Leader Key as Spacebar.
vim.g.mapleader = " "

local set = vim.keymap.set

-- Set lead-c as the command to close current split.
set("n", "<leader>c", vim.cmd.close)
-- Use lead to move between windows.
set("n", "<leader>h", function()
	vim.cmd.wincmd("h")
end)
set("n", "<leader>j", function()
	vim.cmd.wincmd("j")
end)
set("n", "<leader>k", function()
	vim.cmd.wincmd("k")
end)
set("n", "<leader>l", function()
	vim.cmd.wincmd("l")
end)

-- New tab page.
set("n", "<leader>tn", vim.cmd.tabnew)
-- Close tab page.
set("n", "<leader>tc", vim.cmd.tabclose)
-- New tab term.
set("n", "<leader>tt", "<cmd>tab term<cr>")
-- New tab explorer.
set("n", "<leader>te", "<cmd>Texplore<cr>")
-- Next tab.
set("n", "<leader>tl", "<cmd>tabnext<cr>")
-- Last tab.
set("n", "<leader>th", "<cmd>tabprevious<cr>")

-- Explore Home.
set("n", "<leader>eh", "<cmd>Explore ~<cr>")

-- Open new Daily Note.
set("n", "<leader>nd", function()
	local template_path = "~/Notes/Templates/nvim-daily-note.md"
	local daily_note_path = "~/Notes/Daily/" .. vim.fn.strftime("%Y-%m-%d") .. ".md"
	if vim.fn.empty(vim.fn.glob(vim.fn.expand(daily_note_path))) == 1 then
		os.execute("cp " .. template_path .. " " .. daily_note_path)
	end
	vim.cmd.edit(daily_note_path)
end)

-- Open Kratom Log.
set("n", "<leader>nk", function()
	vim.cmd.edit("~/Notes/Log/Kratom/August Kratom Log.md")
end)
