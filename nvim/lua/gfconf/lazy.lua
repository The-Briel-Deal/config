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
	-- For finding things.
	{
		'nvim-telescope/telescope.nvim',
		dependencies = {
			'nvim-lua/plenary.nvim'
		}
	},
	-- For navigating to frequented buffers quickly
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
	-- Install nvim-cmp
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			-- Core Lspconfig Plugin
			"neovim/nvim-lspconfig",
			-- Cmp related extensions
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/cmp-vsnip",
			"hrsh7th/vim-vsnip",
			"VonHeikemen/lsp-zero.nvim",
			{
				-- Mason lets me easily install LSPs
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
	-- Install Neodev for Lua development
	{
		"folke/neodev.nvim",
		dependencies = {
			"hrsh7th/nvim-cmp",
		}
	},
	-- Undo Tree for going back through undos and redos
	{
		"mbbill/undotree"
	},
	-- Zen Mode is a plugin to fullscreen one buffer to remove distractions
	{
		"folke/zen-mode.nvim"
	},
	-- Debug Adapter Protocol
	{
		"mfussenegger/nvim-dap",
	},
})
