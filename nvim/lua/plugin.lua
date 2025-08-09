local M = {}

M.setup = function(opts)
  vim.pack.add({
    { src = 'https://github.com/folke/tokyonight.nvim.git' },
  })
  vim.pack.add({
    { src = 'https://github.com/neovim/nvim-lspconfig' },
  })
  vim.pack.add({
    { src = 'https://github.com/tpope/vim-fugitive.git' },
  })
  vim.pack.add({
    { src = 'https://github.com/stevearc/oil.nvim.git' },
  })
  vim.pack.add({
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter.git' },
  })
  vim.pack.add({
    { src = 'https://github.com/nvim-telescope/telescope.nvim.git' },
  })
  vim.pack.add({
    { src = 'https://github.com/nvim-lua/plenary.nvim.git' },
  })
  vim.pack.add({
    { src = 'https://github.com/Saghen/blink.cmp.git' },
  })
  vim.pack.add({
    { src = 'https://github.com/mfussenegger/nvim-dap.git' },
  })
  vim.pack.add({
    { src = 'https://github.com/theHamsta/nvim-dap-virtual-text.git' },
  })
  vim.pack.add({
    { src = 'https://github.com/igorlfs/nvim-dap-view.git' },
  })
  vim.pack.add({
    { src = 'https://github.com/stevearc/conform.nvim.git' },
  })
  require('oil').setup {
    default_file_explorer = true,
    columns = {
      'permission',
      'size',
      'mtime',
    },
  }
end

return M
