vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.def' },
  callback = function()
      vim.bo.filetype = 'c'
  end,
})
