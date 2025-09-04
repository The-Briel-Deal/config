vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = {'*.yaml', '*.tpl'},
  callback = function()
    local filepath = vim.fn.expand('%:p')
    if string.match(filepath, 'templates') then
      vim.bo.filetype = 'helm'
    end
  end,
})
