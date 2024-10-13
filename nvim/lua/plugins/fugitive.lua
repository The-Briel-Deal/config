-- Sweet Succulent Git Plugin for Vim 🤤
---@type LazySpec
return {
	"tpope/vim-fugitive",
	as = "fugitive",
	cmd = "Git",
	keys = {
		{ "<leader>gs", vim.cmd.Git, mode = "n", desc = "Git Status" },
		{
			"<leader>gb",
			function()
				vim.cmd.Git("blame")
			end,
			mode = "n",
			desc = "Git Blame",
		},
	},
}
