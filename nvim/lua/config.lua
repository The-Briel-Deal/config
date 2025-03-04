local M = {}

M.setup = function(_)
	vim.cmd [[colorscheme tokyonight]]

	vim.go.number = true
	vim.go.relativenumber = true
	vim.go.termsync = false
	vim.go.tabstop = 2
	vim.go.shiftwidth = 2
	vim.g.netrw_banner = false
	vim.g.c_syntax_for_h = 1
	vim.g.clipboard = {
		name = "Tmux Clipboard",
		copy = {
			["+"] = { 'tmux', 'load-buffer', '-w', '-' },
			["*"] = { 'wl-copy' },
		},
		paste = {
			["+"] = { 'tmux', 'save-buffer', '-' },
			["*"] = { 'wl-paste' },
		},
	}

	-- Highlight on Yank
	vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
		pattern = "*",
		callback = function()
			vim.hl.on_yank { higroup = 'IncSearch', timeout = 130 }
		end
	})
end

return M
