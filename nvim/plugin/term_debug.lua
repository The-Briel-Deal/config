vim.api.nvim_create_user_command('GFTermDebug', function(args)
  vim.cmd.packadd('termdebug')
  vim.api.nvim_set_keymap(
    'n',
    '<A-s>',
    ':Step<CR>',
    { desc = 'termdebug: Move onto the next line, step into calls.' }
  )
  vim.api.nvim_set_keymap(
    'n',
    '<A-n>',
    ':Over<CR>',
    { desc = 'termdebug: Move onto the next line, skip over calls.' }
  )
  vim.api.nvim_set_keymap('n', '<A-b>', ':Break<CR>', { desc = 'termdebug: Set breakpoint.' })
  vim.api.nvim_set_keymap('n', '<A-B>', ':Clear<CR>', { desc = 'termdebug: Clear breakpoint.' })
  vim.api.nvim_set_keymap(
    'n',
    '<A-c>',
    ':Continue<CR>',
    { desc = 'termdebug: Continue execution until next breakpoint.' }
  )
  vim.api.nvim_set_keymap(
    'n',
    '<A-k>',
    ':Evaluate<CR>',
    { desc = 'termdebug: Evaluate expression at cursor.' }
  )
end, { desc = "Wrapper around vim's built in termdebug package." })
