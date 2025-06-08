vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'markdown', 'c', 'python', 'make' },
  callback = function(args)
    vim.treesitter.start(args.buf)
  end,
})
