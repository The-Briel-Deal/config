vim.wo.number = true
vim.wo.relativenumber = true
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = {
		"*.c", "*.h", "*.md",
		"*.py", "*.cpp", "*.hpp",
		"*.ts", "*.js", "*.json", "*.lua" },
	callback = function()
		vim.opt.cc = "+1"
		vim.opt.tw = 79
		vim.opt.ts = 4
	end
})
