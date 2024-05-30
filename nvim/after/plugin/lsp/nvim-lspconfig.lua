local lspconfig = require('lspconfig')
local configs = require("lspconfig.configs")
local neodev = require('neodev')
local cmp = require('cmp')
local lsp_zero = require('lsp-zero')

-- Setting up Neodev
neodev.setup({})

-- Setting up Lua Language Server
lspconfig.lua_ls.setup({})

-- Setting up cmp
cmp.setup({
	snippet = {
		expand = function(args)
			vim.fn["vsnip#anonymous"](args.body)
		end
	},
	mapping = cmp.mapping.preset.insert({
		['<C-d>'] = cmp.mapping.scroll_docs(-4),
		['<C-f>'] = cmp.mapping.scroll_docs(4),
		['<C-Space>'] = cmp.mapping.complete(),
		['<CR>'] = cmp.mapping.confirm({ select = false }),
		['<C-j>'] = cmp.mapping.select_next_item(),
		['<C-k>'] = cmp.mapping.select_prev_item(),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
	}, {
		{ name = 'buffer' },
	}),
	formatting = lsp_zero.cmp_format({ details = true })
})

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = {
		{ name = 'buffer' }
	}
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
	mapping = cmp.mapping.preset.cmdline(),
	sources = cmp.config.sources(
		{
			{ name = 'path' }
		},
		{
			{ name = 'cmdline' }
		}
	),
	matching = {
		disallow_symbol_nonprefix_matching = false,
		disallow_fullfuzzy_matching = false,
		disallow_fuzzy_matching = false,
		disallow_partial_matching = false,
		disallow_prefix_unmatching = false,
		disallow_partial_fuzzy_matching = false,
	}
}
)

lsp_zero.on_attach(function(_, bufnr)
	lsp_zero.default_keymaps({ buffer = bufnr })
end)


require('mason').setup()
require('mason-nvim-dap').setup()
require('mason-lspconfig').setup({
	ensure_installed = {},
	handlers = {
		function(server_name)
			require('lspconfig')[server_name].setup({})
		end,
	},
})


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
