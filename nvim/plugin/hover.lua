local hover = require 'hover'

hover.setup {
  init = function()
    require('hover.providers.lsp')
    require('hover.providers.man')
    require('hover.providers.dictionary')
  end,
  title = true,
}

vim.keymap.set('n', 'K', function()
  --- @type integer?
  local hover_win = vim.b[vim.api.nvim_get_current_buf()].hover_preview
  if hover_win and vim.api.nvim_win_is_valid(hover_win) then
    vim.api.nvim_set_current_win(hover_win)
  elseif vim.api.nvim_win_get_config(0).relative == '' then
    -- Only create hover if we're not already in one.
    require('hover').hover({})
  end
end, { desc = 'hover.nvim' })
