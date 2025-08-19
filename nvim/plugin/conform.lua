local conform = require('conform')

---@type fun(opts: conform.setupOpts)
local setup = conform.setup

conform.formatters.pyink = {
  append_args = {
    '--line-length=80',
    '--unstable',
    '--pyink-indentation=2',
    '--pyink-use-majority-quotes',
  },
}

setup({
  formatters_by_ft = {
    python = { 'pyink', lsp_format = 'fallback' },
    lua = { 'stylua', lsp_format = 'fallback' },
    zig = { 'zigfmt', lsp_format = 'fallback' },
  },
})

-- Format
vim.keymap.set({ 'n', 'v' }, '<F3>', function()
  conform.format()
end)
