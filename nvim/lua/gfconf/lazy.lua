local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- Latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Use Telescope For Fuzzy Finding (:
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim'
		}
	},
	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
			"nvim-lua/plenary.nvim"
		}
	},
	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" }
	},
	-- Install Treesitter for Syntax Highlighting
	{
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	},
	-- Sweet Succulent Git Plugin for Vim 🤤
	{
		"tpope/vim-fugitive",
		as = "fugitive"
	},
	-- Set Theme (Choosing flavor in `catppuccin.lua`)
	{
		"catppuccin/nvim",
		as = "catppuccin"
	},
	-- Set LSP (nvim-lspconfig)
	{
		"neovim/nvim-lspconfig",
	},
	-- Install Neodev for Lua development
	{
		"folke/neodev.nvim"
	},
	-- Install nvim-cmp
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
			"VonHeikemen/lsp-zero.nvim",
			{
				"williamboman/mason.nvim",
				opts = {
					ensure_installed = {
						-- C/CPP LSP, Formatter, and DAP
						"clangd",
						"clang-format",
						"codelldb",
						-- Go LSP
						"gopls",
						-- Lua LSP, Formatter, and Linter
						"lua-language-server",
						"luaformatter",
						"luacheck",
					}
				}
			},
			"williamboman/mason-lspconfig.nvim"
		}
	},
	{
		"mbbill/undotree"
	},
	{
		"folke/zen-mode.nvim"
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = {
			handlers = {}
		},
	},
	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio"
		}
	},
	-- A bunch of miscellaneous mini plugins
	{
		'echasnovski/mini.nvim',
		version = '*',
	},
	--- Google Plugins
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



})
