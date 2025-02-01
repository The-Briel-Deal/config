vim.api.nvim_create_autocmd('FileType', {
	pattern = {'markdown', 'c', 'python'},
	callback = function(args)
		vim.treesitter.start(args.buf)
	end
})
