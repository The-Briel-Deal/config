require("blink.cmp").setup({
	completion = {
		menu = {
			auto_show = false
		},
		documentation = {
			auto_show = true
		}
	},
	keymap = {
		['<C-n>'] = { 'show', 'select_next', 'fallback' },
		['<C-p>'] = { 'show', 'select_prev', 'fallback' }
	}
})

vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(args)
		local cmp = require("blink.cmp")
		local set = vim.keymap.set

		local client = vim.lsp.get_client_by_id(args.data.client_id)
		assert(client)

		local function on_list(options)
			vim.fn.setqflist({}, ' ', options)
			vim.cmd.cfirst()
		end


		-- Go to Definition
		set('n', 'gd', function()
			vim.lsp.buf.definition({ on_list = on_list })
		end, { buffer = true })

		-- Go to References
		set('n', 'gr', function()
			vim.lsp.buf.references({ includeDeclaration = false }, { on_list = on_list })
		end, { buffer = true, nowait = true })

		-- Show Diagnostics
		set('n', 'gl', function()
			vim.diagnostic.open_float({})
		end, { buffer = true })

		-- Rename
		set('n', '<F2>', function()
			vim.lsp.buf.rename()
		end, { buffer = true })

		vim.api.nvim_create_user_command("Rename",
			function(_) vim.lsp.buf.rename() end,
			{}
		)

		-- Format
		set('n', '<F3>', function()
			vim.lsp.buf.format()
		end, { buffer = true })

		vim.api.nvim_create_user_command("Format",
			function(_) vim.lsp.buf.format() end,
			{}
		)

		-- Inlay Hints
		vim.lsp.inlay_hint.enable(true)

		-- Toggle
		set('n', '<leader>in', function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
		end)
	end
})
