vim.lsp.start({
  name = 'zls',
  cmd = { 'zls' },
  root_dir = vim.fs.dirname(
    vim.fs.find(
      { 'zls.json', 'build.zig', '.git' },
      { upward = true, path = vim.api.nvim_buf_get_name(0) }
    )[1]
  ),
  settings = {
    zls = {
      enable_build_on_save = true,
    },
  },
})
