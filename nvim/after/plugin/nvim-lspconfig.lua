local lspconfig = require('lspconfig')
local neodev = require('neodev')
local cmp = require('cmp')

-- Setting up my Neodev
neodev.setup()

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
		['<CR>'] = cmp.mapping.scroll_docs({ select = true }),
	}),
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'vsnip' },
	}, {
		{ name = 'buffer' },
	})
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

-- All of my Lsp Binds go in here.
function SetupLspBinds(args)
	vim.keymap.set("n", "<leader>lh", vim.lsp.buf.hover, { buffer = args.buf })
	vim.keymap.set("n", "<leader>lf", vim.lsp.buf.format, { buffer = args.buf })
	vim.keymap.set("i", "<C-A>", vim.lsp.buf.completion, {})
end

-- Here I setup an autocommand to run setup my keymaps above.
vim.api.nvim_create_autocmd('LspAttach',
	{
		callback = SetupLspBinds
	}
)
