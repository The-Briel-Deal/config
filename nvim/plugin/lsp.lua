vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(_)
		local function on_list(options)
			vim.fn.setqflist({}, ' ', options)
			vim.cmd.cfirst()
		end

		local set = vim.keymap.set

		-- Go to Definition
		set('n', 'gd', function()
			vim.lsp.buf.definition({ on_list = on_list })
		end, { buffer = true })

		-- Go to References
		set('n', 'gr', function()
			vim.lsp.buf.references({ includeDeclaration = false }, { on_list = on_list })
		end, { buffer = true, nowait = true })

		-- Format
		set('n', '<F3>', function()
			vim.lsp.buf.format()
		end, { buffer = true })

		vim.api.nvim_create_user_command("Format", function(_) vim.lsp.buf.format() end, {})
	end
})
