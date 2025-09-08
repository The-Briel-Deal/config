vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = { '*.def', '*.c' },
  callback = function()
    vim.bo.filetype = 'c'
    local filepath = vim.fn.expand('%:p')
    if string.match(filepath, 'gdb') then
      vim.bo.filetype = 'cpp'
    end
  end,
})
