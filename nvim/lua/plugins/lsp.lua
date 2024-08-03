-- Install nvim-cmp and other lsp things!
local CIDER_LSP_DIR = '/google/bin/releases/cider/ciderlsp/ciderlsp'

---@type LazySpec
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",

	},
	lazy = false,
	config = function()
		require("mason").setup()
		local mason_lsp_config = require("mason-lspconfig")
		local nvim_lspconfig = require("lspconfig")
		local lsp_configs = require("lspconfig.configs")

		mason_lsp_config.setup({
			ensure_installed = {},
			handlers = {
				function(server_name)
					nvim_lspconfig[server_name].setup({})
				end,
			}
		})

		-- Setup CiderLSP if its path exists.
		if (vim.fn.isdirectory(CIDER_LSP_DIR) == 1) then
			lsp_configs.ciderlsp = {
				default_config = {
					cmd = { CIDER_LSP_DIR, '--tooltag=nvim-lsp', '--noforward_sync_responses' },
					filetypes = { "c", "cpp", "java", "kotlin", "objc", "proto", "textproto", "go", "python", "bzl", "typescript" },
					offset_encoding = 'utf-8',
					root_dir = nvim_lspconfig.util.root_pattern('google3/*BUILD'),
					settings = {},
				}
			}
			nvim_lspconfig.ciderlsp.setup({})
		end

		if (vim.fn.executable('lua-language-server') == 1) then
			nvim_lspconfig.lua_ls.setup({})
		end
		if (vim.fn.executable('clangd') == 1) then
			nvim_lspconfig.clangd.setup({})
		end
	end,
	opts = {
	},
	keys = {
		{ "gd",   vim.lsp.buf.definition,                  desc = "Goto Definition" },
		{ "gD",   vim.lsp.buf.declaration,                 desc = "Goto Declaration" },
		{ "gr",   vim.lsp.buf.references,                  desc = "Goto References" },
		{ "gi",   vim.lsp.buf.implementation,              desc = "Goto Implementation" },
		{ "gy",   vim.lsp.buf.type_definition,             desc = "Goto Type Definition" },
		{ "gl",   vim.lsp.diagnostic.get_line_diagnostics, desc = "Goto Type Definition" },
		{ "<F3>", vim.lsp.buf.format,                      desc = "Format Document" },
	},
}
