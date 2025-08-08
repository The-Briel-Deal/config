vim.pack.add({
  { src = 'https://github.com/neovim/nvim-lspconfig' },
})

vim.lsp.config('luals', {
  name = 'luals',
  cmd = { 'lua-language-server' },
  filetypes = { 'lua' },
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
        library = {
          vim.env.VIMRUNTIME,
          '${3rd}/busted/library',
          '${3rd}/luassert/library',
          '${3rd}/luv/library',
        },
        checkThirdParty = 'Enable',
      },
    },
  },
})
vim.lsp.enable({ 'ts_ls', 'pyright', 'clangd', 'glsl_analyzer', 'gopls', 'luals', 'zls' })

require('blink.cmp').setup({
  completion = {
    menu = {
      auto_show = false,
    },
    documentation = {
      auto_show = true,
    },
  },
  keymap = {
    ['<C-n>'] = { 'show', 'select_next', 'fallback' },
    ['<C-p>'] = { 'show', 'select_prev', 'fallback' },
  },
})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local set = vim.keymap.set

    local client = vim.lsp.get_client_by_id(args.data.client_id)
    assert(client)

    local function on_list(options)
      vim.fn.setqflist({}, ' ', options)
      vim.cmd.cfirst()
    end

    -- Go to Definition
    set('n', 'gd', function()
      vim.lsp.buf.definition({ on_list = on_list })
    end, { buffer = true })

    -- Go to References
    set('n', 'gr', function()
      vim.lsp.buf.references({ includeDeclaration = false }, { on_list = on_list })
    end, { buffer = true, nowait = true })

    -- Show Diagnostics
    set('n', 'gl', function()
      vim.diagnostic.open_float({})
    end, { buffer = true })

    -- Rename
    set('n', '<F2>', function()
      vim.lsp.buf.rename()
    end, { buffer = true })

    vim.api.nvim_create_user_command('Rename', function(_)
      vim.lsp.buf.rename()
    end, {})

    vim.api.nvim_create_user_command('Format', function(_)
      vim.lsp.buf.format()
    end, {})

    -- Inlay Hints
    vim.lsp.inlay_hint.enable(true)

    -- Toggle
    set('n', '<leader>in', function()
      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
    end)
  end,
})
