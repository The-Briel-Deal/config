-- Install nvim-cmp and other lsp things!
---@type LazySpec
return {
	"neovim/nvim-lspconfig",
	config = function()
		local nvim_lspconfig = require("lspconfig")
		local lsp_configs = require("lspconfig.configs")

		lsp_configs.ciderlsp = {
			default_config = {
				cmd = { '/google/bin/releases/cider/ciderlsp/ciderlsp', '--tooltag=nvim-lsp', '--noforward_sync_responses' },
				filetypes = { "c", "cpp", "java", "kotlin", "objc", "proto", "textproto", "go", "python", "bzl", "typescript" },
				offset_encoding = 'utf-8',
				root_dir = nvim_lspconfig.util.root_pattern('google3/*BUILD'),
				settings = {},
			}
		}
		nvim_lspconfig.ciderlsp.setup({})
	end,
	keys = {
		{ "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
		{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
		{ "gr", vim.lsp.buf.references, desc = "References"},
		{ "gI", vim.lsp.buf.implementation, desc = "Goto Implementation" },
		{ "gy", vim.lsp.buf.type_definition, desc = "Goto T[y]pe Definition" },
	},
}
