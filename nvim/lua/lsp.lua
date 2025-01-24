
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(_ev)

    local function on_list(options)
      vim.fn.setqflist({}, ' ', options)
      vim.cmd.cfirst()
    end
    
    local set = vim.keymap.set
    
    set('n', 'gd', function()
      vim.lsp.buf.definition({ on_list = on_list})
    end, {buffer = true})
    
    set('n', 'gr', function()
      vim.lsp.buf.references({includeDeclaration = false}, { on_list = on_list})
    end, {buffer = true, nowait = true})

	end
})

