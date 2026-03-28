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
