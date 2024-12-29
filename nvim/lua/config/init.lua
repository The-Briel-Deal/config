vim.go.number = true
vim.go.relativenumber = true
vim.go.termsync = false
vim.go.tabstop = 2
vim.go.shiftwidth = 2
vim.g.netrw_banner = false
vim.g.clipboard = {
	name = "OSC 52",
	copy = {
		["+"] = require("vim.ui.clipboard.osc52").copy("+"),
		["*"] = require("vim.ui.clipboard.osc52").copy("*"),
	},
	paste = {
		["+"] = require("vim.ui.clipboard.osc52").paste("+"),
		["*"] = require("vim.ui.clipboard.osc52").paste("*"),
	},
}

require("config.keymap")
