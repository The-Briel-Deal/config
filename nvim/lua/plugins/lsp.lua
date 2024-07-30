-- Install nvim-cmp and other lsp things!
return {
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
}
