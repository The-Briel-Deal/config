-- Install nvim-cmp and other lsp things!
---@type LazySpec
return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		-- Core Lspconfig Plugin
		"neovim/nvim-lspconfig",
		-- Cmp related extensions
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
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
		{
			"williamboman/mason-lspconfig.nvim",
			opts = {
				ensure_installed = {},
				handlers = {
					function(server_name)
						require('lspconfig')[server_name].setup({})
					end,
				},
			},
		},
	},
	opts = function()
		return {
		snippet = {
			expand = function(args)
				vim.fn["vsnip#anonymous"](args.body)
			end
		},
		sources = require("cmp").config.sources({
			{ name = 'nvim_lsp' },
		}, {
			{ name = 'buffer' },
		})
	}
	end,
	keys = {
      { "gd", vim.lsp.buf.definition, desc = "Goto Definition", has = "definition" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "gr", vim.lsp.buf.references, desc = "References", nowait = true },
      { "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
      { "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
	-- TODO: Add shift-k for hover.
	},
}
