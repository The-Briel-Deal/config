local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
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
	-- Set Theme (Choosing flavor in catppuccin.lua)
	{
		"catppuccin/nvim",
		as = "catppuccin"
	},
	-- Set LSP (nvim-lspconfig)
	{
		"neovim/nvim-lspconfig",
	},
	-- Install Neodev for lua development
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
			"williamboman/mason.nvim",
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
		"mfussenegger/nvim-dap"
	},
	{
		"ndonfris/fish-lsp"
	},
	{
		"vhyrro/luarocks.nvim",
		priority = 1000,
		config = true,
	},
	{
		"nvim-neorg/neorg",
		dependencies = { "luarocks.nvim" },
		lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
		version = "*", -- Pin Neorg to the latest stable release
		config = true,
	}
})
