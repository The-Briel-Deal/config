local conform = require('conform')

---@type fun(opts: conform.setupOpts)
local setup = conform.setup

setup({
  formatters_by_ft = {
    python = { 'pyink', lsp_format = 'fallback' },
    lua = { 'stylua', lsp_format = 'fallback' },
  },
})

-- Format
vim.keymap.set({ 'n', 'v' }, '<F3>', function()
  conform.format()
end)
