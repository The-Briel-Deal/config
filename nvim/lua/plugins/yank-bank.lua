return {
	"ptdewey/yankbank-nvim",
	dependencies = "kkharji/sqlite.lua",
	config = function()
		require("yankbank").setup({
			persist_type = "sqlite",
		})
	end,
	cmd = "YankBank",
	keys = {
		{ "<leader>y", "<cmd>YankBank<CR>" },
	},
}
