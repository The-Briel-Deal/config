vim.lsp.start({
  name = 'zls',
  cmd = { 'zls' },
  root_dir = vim.fs.dirname(
    vim.fs.find(
      { 'zls.json', 'build.zig', '.git' },
      { upward = true, path = vim.api.nvim_buf_get_name(0) }
    )[1]
  ),
})
vim.lsp.start({
  name = 'luals',
  cmd = { 'zls' },
  filetypes = { 'zig', 'zir' },
  root_markers = { 'zls.json', 'build.zig', '.git' },
  workspace_required = false,
})
