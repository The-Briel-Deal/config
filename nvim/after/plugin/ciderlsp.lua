local lspconfig = require("lspconfig")
local configs = require("lspconfig.configs")

if vim.fn.hostname() == "gf.c.googlers.com" then
	configs.ciderlsp = {
		default_config = {
			cmd = { "/google/bin/releases/cider/ciderlsp/ciderlsp", "--tooltag=nvim-cmp", "--noforward_sync_responses" },
			filetypes = { "c", "cpp", "java", "kotlin", "objc", "proto", "textproto", "go", "python", "bzl" },
			root_dir = lspconfig.util.root_pattern("BUILD"),
			settings = {},
		},
	}

	lspconfig.ciderlsp.setup({
		capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities()),
	})
end

