local nv_ts = require('nvim-treesitter')
nv_ts.setup()
nv_ts.install({
  'asm',
  'c',
  'cpp',
  'lua',
  'markdown',
  'markdown_inline',
  'python',
  'fish',
  'bash',
  'rust',
  'meson',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'asm',
    'c',
    'cpp',
    'lua',
    'markdown',
    'python',
    'fish',
    'bash',
    'rust',
    'meson',
  },
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
