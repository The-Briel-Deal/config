-- Install lazydev for Lua development
return {
	"folke/lazydev.nvim",
	ft = "lua",
	dependencies = { "Bilal2453/luvit-meta", lazy = true }, -- `vim.uv` typings
	opts = {
		library = {
			"lazy.nvim",
			{ path = "luvit-meta/library", words = { "vim%.uv" } },
		},
	},
}
