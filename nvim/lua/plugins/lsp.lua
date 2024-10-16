-- Install nvim-cmp and other lsp things!
local CIDER_LSP_DIR = "/google/bin/releases/cider/ciderlsp/ciderlsp"

---@type LazySpec
return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		{
			"hrsh7th/nvim-cmp",
			opts = function()
				return {
					snippet = {
						expand = function(args)
							vim.snippet.expand(args.body)
						end,
					},
					mapping = require("cmp").mapping.preset.insert({
						["<C-b>"] = require("cmp").mapping.scroll_docs(-4),
						["<C-f>"] = require("cmp").mapping.scroll_docs(4),
						["<C-Space>"] = require("cmp").mapping.complete(),
						["<C-e>"] = require("cmp").mapping.abort(),
						["<CR>"] = require("cmp").mapping.confirm({ select = true }),
					}),
					sources = require("cmp").config.sources({
						{ name = "nvim_lsp" },
					}),
				}
			end,
		},
		"hrsh7th/cmp-nvim-lsp",
		{
			"mrcjkb/rustaceanvim",
			version = "^5", -- Recommended
			lazy = false, -- This plugin is already lazy
		},
	},
	lazy = false,
	config = function()
		local mason = require("mason")
		local mason_lsp_config = require("mason-lspconfig")
		local nvim_lspconfig = require("lspconfig")
		local lsp_configs = require("lspconfig.configs")

		mason.setup({})

		---@type boolean
		local mason_autostart = vim.fn.has_key(vim.fn.environ(), "NO_MASON_AUTOSTART") == 0
		mason_lsp_config.setup({
			ensure_installed = {},
			handlers = {
				function(server_name)
					if server_name == "rust_analyzer" then
						return -- Using Rustaceanvim
					end
					nvim_lspconfig[server_name].setup({
						autostart = mason_autostart,
					})
				end,
			},
		})

		-- Setup CiderLSP if its path exists.
		if vim.fn.executable(CIDER_LSP_DIR) == 1 then
			-- Cider LSP
			lsp_configs.ciderlsp = {
				default_config = {
					cmd = { CIDER_LSP_DIR, "--tooltag=nvim-lsp", "--noforward_sync_responses" },
					filetypes = {
						"c",
						"cpp",
						"java",
						"kotlin",
						"objc",
						"proto",
						"textproto",
						"go",
						"python",
						"bzl",
						"typescript",
					},
					offset_encoding = "utf-8",
					root_dir = nvim_lspconfig.util.root_pattern("google3/*BUILD"),
					settings = {},
				},
			}
			nvim_lspconfig.ciderlsp.setup({})
			-- Analysis LSP
			lsp_configs.analysislsp = {
				default_config = {
					cmd = {
						"/google/bin/users/lerm/glint-ale/analysis_lsp/server",
						"--lint_on_save=false",
						"--max_qps=10",
					},
					filetypes = { "c", "cpp", "java", "kotlin", "objc", "proto", "textproto", "go", "python", "bzl" },
					offset_encoding = "utf-8",
					root_dir = nvim_lspconfig.util.root_pattern("google3/*BUILD"),
					settings = {},
				},
			}
			nvim_lspconfig.analysislsp.setup({})
		end
	end,
	opts = {},
	keys = {
		{ "gd", vim.lsp.buf.definition, desc = "Goto Definition" },
		{ "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
		{ "gr", vim.lsp.buf.references, desc = "Goto References" },
		{ "gi", vim.lsp.buf.implementation, desc = "Goto Implementation" },
		{ "gy", vim.lsp.buf.type_definition, desc = "Goto Type Definition" },
		{ "gl", vim.diagnostic.open_float, desc = "Open Diagnostics in Float" },
		{ "gq", vim.diagnostic.setqflist, desc = "Add All Diagnostics to Quickfix List" },
		{ "<F2>", vim.lsp.buf.rename, desc = "Rename Symbol" },
		{ "<F3>", vim.lsp.buf.format, desc = "Format Document" },
		{ "<F4>", vim.lsp.buf.code_action, desc = "Code Action" },
	},
}
