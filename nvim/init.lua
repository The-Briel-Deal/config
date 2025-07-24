vim.pack.add{
  { src = 'https://github.com/neovim/nvim-lspconfig' },
}

vim.lsp.enable('ts_ls')

require('plugin').setup {}
require('config').setup {}
require('keymap').setup {}
