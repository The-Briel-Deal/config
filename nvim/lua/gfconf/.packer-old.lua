vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
	-- Use Packer
	use {
		'wbthomason/packer.nvim'
	}

	-- Use Telescope For Fuzzy Finding (:
	use {
		'nvim-telescope/telescope.nvim',
		requires = {
			'nvim-lua/plenary.nvim'
		}
	}

	-- Install Treesitter for Syntax Highlighting
	use {
		'nvim-treesitter/nvim-treesitter',
		run = ':TSUpdate'
	}

	-- Sweet Succulent Git Plugin for Vim 🤤
	use {
		"tpope/vim-fugitive",
		as = "fugitive"
	}

	-- Set Theme (Choosing flavor in catppuccin.lua)
	use {
		"catppuccin/nvim",
		as = "catppuccin"
	}

	-- Set LSP (nvim-lspconfig)
	use {
		"neovim/nvim-lspconfig",
	}

	-- Install Neodev for lua development
	use {
		"folke/neodev.nvim"
	}

	-- Install nvim-cmp
	use {
		"hrsh7th/nvim-cmp",
		requires = {
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
	}
end)
