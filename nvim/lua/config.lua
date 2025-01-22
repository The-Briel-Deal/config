local M = {}

M.setup = function(opts)
  vim.cmd[[colorscheme tokyonight]]

  vim.go.number = true
  vim.go.relativenumber = true
  vim.go.termsync = false
  vim.go.tabstop = 2
  vim.go.shiftwidth = 2
  vim.g.netrw_banner = false
  vim.g.clipboard = {
    name = "Tmux Clipboard",
    copy = {
      ["+"] = {'tmux', 'load-buffer', '-'},
      ["*"] = {'tmux', 'load-buffer', '-'},
    },
    paste = {
      ["+"] = {'tmux', 'save-buffer', '-'},
      ["*"] = {'tmux', 'save-buffer', '-'},
    },
  }
  
  -- Highlight on Yank
  vim.api.nvim_create_autocmd({ 'TextYankPost' }, {
    pattern = "*",
    callback = function()
      vim.hl.on_yank { higroup = 'IncSearch', timeout = 130 }
    end
  })
end

return M
