local nv_ts = require('nvim-treesitter')
nv_ts.setup()
nv_ts.install({
  'c',
  'cpp',
  'python',
  'lua',
  'markdown',
  'markdown_inline',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'c', 'cpp', 'python', 'lua', 'markdown' },
  callback = function()
    -- syntax highlighting, provided by Neovim
    vim.treesitter.start()
    -- folds, provided by Neovim
    vim.wo.foldlevel = 4
    vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    vim.wo.foldmethod = 'expr'
    -- indentation, provided by nvim-treesitter
    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  end,
})
