if (vim.fn.hostname() == "gf.c.googlers.com") then
	--- Google Plugins
	return {
		-- Figtree
		{
			url = 'sso://user/jackcogdill/nvim-figtree',
			keys = {
				{
					'<Leader>gf',
					function()
						require('figtree').toggle()
					end,
				},
			},
			opts = {
				-- see |figtree-configuration| for all possible options
			},
		},
		-- Telescope Codesearch
		{
			"nvim-telescope/telescope.nvim",
			-- Add telescope-codesearch as a dependency of telescope.nvim.
			-- This ensures that telescope-codesearch is loaded when telescope.nvim is
			-- loaded. So if you use the `Telescope` ex-command `codesearch` will
			-- immediately appear as one of the available pickers.
			dependencies = {
				{
					"vintharas/telescope-codesearch.nvim",
					url = "sso://user/vintharas/telescope-codesearch.nvim",
					-- lazy.nvim relies on a declarative api (LazySpec) to configure your
					-- plugins. See https://github.com/folke/lazy.nvim#-plugin-spec for
					-- more information about the available options.
					keys = {
						{
							"<leader>fcf",
							"<cmd>Telescope codesearch find_files<cr>",
							desc = "Find codesearch files",
						},
						{
							"<leader>fcq",
							"<cmd>Telescope codesearch find_query<cr>",
							desc = "Find codesearch query",
						},
					},
					config = function()
						-- This asks telescope to load the codesearch extension and makes
						-- the 'codesearch' picker available through the `Telescope` command.
						require("telescope").load_extension("codesearch")
					end,
				},
			},
		},
	}
end
return {}
