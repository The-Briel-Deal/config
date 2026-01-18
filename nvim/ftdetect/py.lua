vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.pyx' },
  callback = function()
    vim.bo.filetype = 'python'
  end,
})
