-- A delicious colorscheme for dogs!
return {
	"folke/tokyonight.nvim",
	lazy = true,
	priority = 1000,
	init = function()
		vim.cmd.colorscheme("tokyonight")
	end,
}
