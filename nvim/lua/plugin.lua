local M = {}

M.setup = function(opts)
  vim.pack.add({
    { src = 'https://github.com/folke/tokyonight.nvim.git' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/linux-cultist/venv-selector.nvim.git' },
    { src = 'https://github.com/tpope/vim-fugitive.git' },
    { src = 'https://github.com/tpope/vim-dadbod.git' },
    { src = 'https://github.com/kristijanhusak/vim-dadbod-ui.git' },
    { src = 'https://github.com/kristijanhusak/vim-dadbod-completion.git' },
    { src = 'https://github.com/stevearc/oil.nvim.git' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter.git' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim.git' },
    { src = 'https://github.com/nvim-lua/plenary.nvim.git' },
    { src = 'https://github.com/Saghen/blink.cmp.git', version = 'v1.6.0' },
    { src = 'https://github.com/mfussenegger/nvim-dap.git' },
    { src = 'https://github.com/theHamsta/nvim-dap-virtual-text.git' },
    { src = 'https://github.com/igorlfs/nvim-dap-view.git' },
    { src = 'https://github.com/stevearc/conform.nvim.git' },
    { src = 'https://github.com/MeanderingProgrammer/render-markdown.nvim.git' },
    { src = 'https://github.com/ramilito/kubectl.nvim.git', version = 'v2.24.0' },
  })
  require('venv-selector').setup {}
  require('tokyonight').setup {
    transparent = true,
  }
  require('kubectl').setup {
    lsp = { enabled = true },
    completion = { follow_cursor = false },
    log_level = vim.log.levels.INFO,
    auto_refresh = {
      enabled = true,
      interval = 300, -- milliseconds
    },
    diff = {
      bin = 'kubediff', -- or any other binary
    },
    kubectl_cmd = { cmd = 'kubectl', env = {}, args = {}, persist_context_change = false },
    terminal_cmd = nil, -- Exec will launch in a terminal if set, i.e. "ghostty -e"
    namespace = 'All',
    namespace_fallback = {}, -- If you have limited access you can list all the namespaces here
    headers = {
      enabled = true,
      hints = true,
      context = true,
      heartbeat = true,
      blend = 20,
      skew = {
        enabled = true,
        log_level = vim.log.levels.OFF,
      },
    },
    lineage = {
      enabled = true, -- This feature is in beta at the moment
    },
    logs = {
      prefix = true,
      timestamps = true,
      since = '5m',
    },
    alias = {
      apply_on_select_from_history = true,
      max_history = 5,
    },
    filter = {
      apply_on_select_from_history = true,
      max_history = 10,
    },
    filter_label = {
      max_history = 20,
    },
    float_size = {
      -- Almost fullscreen:
      -- width = 1.0,
      -- height = 0.95, -- Setting it to 1 will cause bottom to be cutoff by statuscolumn

      -- For more context aware size:
      width = 0.9,
      height = 0.8,

      -- Might need to tweak these to get it centered when float is smaller
      col = 10,
      row = 5,
    },
    statusline = {
      enabled = true,
    },
    obj_fresh = 5, -- highlight if creation newer than number (in minutes)
    api_resources_cache_ttl = 60 * 60 * 3, -- 3 hours in seconds
  }
  require('oil').setup {
    default_file_explorer = true,
    columns = {
      'permission',
      'size',
      'mtime',
    },
  }
end

return M
