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
		{
			url = 'sso://@user/chmnchiang/google-comments',
			requires = { 'nvim-lua/plenary.nvim' },
			lazy = false,
			config = function()
				-- Use the default option.
				require('google.comments').setup()
				--[[
				-- Here are all the options and their default values:
				require('google.comments').setup {
					--- The command and args for fetching comments.
					--- Example: {'comments', '--arg1'}
					--- Refer to `get_comments.par --help` to see all the options.
					command = { '/google/bin/releases/editor-devtools/get_comments.par',
						'--full', '--json', "-x=''" },
					--- The name of the sign to show on the sign column.
					--- You might want to define one using `sign_define`.
					--- Example:
					---   vim.fn.sign_define('COMMENTS_ICON', {text = ' '})
					---   -- And then set `sign = 'COMMENTS_ICON'` in the options.
					sign = nil,
					--- Fetch the comments after calling `setup`.
					auto_fetch = true,
					display = {
						--- The width of the comment display window.
						width = 40,
						--- When showing file paths, use relative paths or not.
						relative_path = true,
						--- Enable viewing comments through floating window
						floating = false,
						--- Options used when creating the floating window.
						floating_window_options = require('google.comments.options')
						    .default_floating_window_options,
					},
				}
				--]]
				-- here are some mappings you might want:
				vim.api.nvim_set_keymap('n', ']lc',
					[[<Cmd>lua require('google.comments').goto_next_comment()<CR>]],
					{ noremap = true, silent = true })
				vim.api.nvim_set_keymap('n', '[lc',
					[[<Cmd>lua require('google.comments').goto_prev_comment()<CR>]],
					{ noremap = true, silent = true })
				vim.api.nvim_set_keymap('n', '<Leader>gc',
					[[<Cmd>lua require('google.comments').toggle_line_comments()<CR>]],
					{ noremap = true, silent = true })
				vim.api.nvim_set_keymap('n', '<Leader>ac',
					[[<Cmd>lua require('google.comments').show_all_comments()<CR>]],
					{ noremap = true, silent = true })
			end
		}
	}
end
return {}
