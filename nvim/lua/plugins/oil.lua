return {
	"stevearc/oil.nvim",
	lazy = false,
	---@module 'oil'
	---@type oil.SetupOpts
	opts = {
		default_file_explorer = true,
		columns = {
			"icon",
			"permission",
			"size",
			"mtime",
		},
	},
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	cmd = "Oil",
	keys = {
		{
			"<leader>pv",
			function()
				require("oil").open()
			end,
			desc = "Open Oil",
		},
	},
}
