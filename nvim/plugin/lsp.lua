vim.lsp.config('lua_ls', {
  on_init = function(client)
    if client.workspace_folders then
      local path = client.workspace_folders[1].name
      if
        path ~= vim.fn.stdpath('config')
        and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
      then
        return
      end
    end

    client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      runtime = {
        -- Tell the language server which version of Lua you're using (most
        -- likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Tell the language server how to find Lua modules same way as Neovim
        -- (see `:h lua-module-load`)
        path = {
          'lua/?.lua',
          'lua/?/init.lua',
        },
      },
      -- Make the server aware of Neovim runtime files
      workspace = {
        checkThirdParty = false,
        -- library = {
        --   vim.env.VIMRUNTIME,
        -- },
        -- Or pull in all of 'runtimepath'.
        -- NOTE: this is a lot slower and will cause issues when working on
        -- your own configuration.
        -- See https://github.com/neovim/nvim-lspconfig/issues/3189
        library = vim.api.nvim_get_runtime_file('', true),
      },
    })
  end,
  settings = {
    Lua = {},
  },
})

local zig_lib_path = function()
  local cwd = vim.fn.getcwd()
  local start_index, _ = string.find(cwd, 'Code/zig')
  if start_index then
    return cwd .. '/lib'
  end
  return nil
end

vim.lsp.config('zls', {
  ---@param client vim.lsp.Client
  ---@param bufnr integer
  on_attach = function(client, bufnr)
    _ = bufnr
    client.settings.zls['zig_lib_path'] = zig_lib_path()
  end,
  settings = {
    zls = {
      zig_lib_path = nil,
      enable_build_on_save = false,
    },
  },
})

vim.lsp.config('pyright', {
  -- Starts with '.git' because one of my work projects uses uv workspaces.
  root_markers = { '.git', 'pyproject.toml', 'setup.py', 'requirements.txt' },
  settings = {
    python = {
      analysis = {
        logLevel = 'Trace',
      },
    },
  },
})

vim.lsp.enable({
  'ts_ls',
  'pyright',
  'clangd', --[['glsl_analyzer', --]]
  'gopls',
  'lua_ls',
  'zls',
  'angularls',
})

require('blink.cmp').setup({
  cmdline = {
    enabled = true,
    keymap = {
      preset = 'inherit',
    },
  },
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
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
    per_filetype = {
      sql = { 'snippets', 'dadbod', 'buffer' },
      mysql = { 'snippets', 'dadbod', 'buffer' },
    },
    -- add vim-dadbod-completion to your completion providers
    providers = {
      dadbod = { name = 'Dadbod', module = 'vim_dadbod_completion.blink' },
    },
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

    set('n', 'gi', function()
      vim.lsp.buf.implementation({})
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
