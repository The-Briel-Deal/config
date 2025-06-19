local hover = require 'hover'

hover.setup {
  init = function()
    require('hover.providers.lsp')
    require('hover.providers.man')
    require('hover.providers.dictionary')
  end,
  title = true,
}
local set = vim.keymap.set

set('n', 'K', function()
  --- @type integer?
  local hover_win = vim.b[vim.api.nvim_get_current_buf()].hover_preview
  if hover_win and vim.api.nvim_win_is_valid(hover_win) then
    vim.api.nvim_set_current_win(hover_win)
  elseif vim.api.nvim_win_get_config(0).relative == '' then
    -- Only create hover if we're not already in one.
    require('hover').hover({})
  end
end, { desc = 'Open hover float.' })

set('n', '<C-n>', function()
  require('hover').hover_switch('next', {})
end, { desc = 'Select next hover tab.' })

set('n', '<C-p>', function()
  require('hover').hover_switch('previous', {})
end, { desc = 'Select next hover tab.' })
