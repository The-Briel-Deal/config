local nv_ts = require('nvim-treesitter')
nv_ts.setup()
nv_ts.install({
  'asm',
  'bash',
  'c',
  'cpp',
  'fish',
  'glsl',
  'javascript',
  'lua',
  'markdown',
  'markdown_inline',
  'meson',
  'ninja',
  'python',
  'rust',
  'typescript',
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = {
    'asm',
    'bash',
    'c',
    'cpp',
    'fish',
    'glsl',
    'javascript',
    'lua',
    'markdown',
    'meson',
    'ninja',
    'python',
    'rust',
    'typescript',
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
