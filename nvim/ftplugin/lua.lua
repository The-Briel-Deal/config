vim.lsp.start({
  name = 'luals',
  cmd = { 'lua-language-server' },
  root_dir = vim.fs.dirname(
    vim.fs.find(
      { '.luarc.json', 'init.lua', '.gitignore' },
      { upward = true, path = vim.api.nvim_buf_get_name(0) }
    )[1]
  ),
  settings = {
    Lua = {
      hint = { enable = true },
      workspace = {
        library = { vim.env.VIMRUNTIME },
      },
    },
  },
})
