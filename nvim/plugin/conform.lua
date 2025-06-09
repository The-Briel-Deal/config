local conform = require('conform')

---@type fun(opts: conform.setupOpts)
local setup = conform.setup

setup({formatters_by_ft = {python = {'pyink', lsp_format = 'fallback'}}})

