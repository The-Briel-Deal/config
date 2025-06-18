local dap = require('dap') ---@module 'nvim-dap.lua.dap'
local assert = require('luassert')

dap.defaults.fallback.external_terminal = {
  command = 'tmux',
  args = { 'splitw' },
}

dap.adapters.python = function(cb, config)
  if config.request == 'attach' then
    ---@diagnostic disable-next-line: undefined-field
    local port = (config.connect or config).port
    ---@diagnostic disable-next-line: undefined-field
    local host = (config.connect or config).host or '127.0.0.1'
    cb({
      type = 'server',
      port = assert(port, '`connect.port` is required for a python `attach` configuration'),
      host = host,
      options = {
        source_filetype = 'python',
      },
    })
  else
    cb({
      type = 'executable',
      command = 'path/to/virtualenvs/debugpy/bin/python',
      args = { '-m', 'debugpy.adapter' },
      options = {
        source_filetype = 'python',
      },
    })
  end
end

dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch',
    name = 'Launch file',

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = '${file}', -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return '/usr/bin/python'
      end
    end,
  },
  {
    -- The first three options are required by nvim-dap
    type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'attach',
    name = 'Attach to debugpy server',
    connect = { host = '127.0.0.1', port = 12345 },

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = '.venv/bin/grr_worker', -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return '/usr/bin/python'
      end
    end,
  },
}

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = os.getenv('HOME')
    .. '/.local/share/debug_adapters/extension/debugAdapters/bin/OpenDebugAD7',
}

dap.configurations.c = {
  {
    name = 'generic - Launch',
    type = 'cppdbg',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable:', vim.fn.getcwd() .. '/', 'file')
    end,
    externalConsole = true,
  },
  {
    name = 'generic - Attach to gdb-server',
    type = 'cppdbg',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable:', vim.fn.getcwd() .. '/', 'file')
    end,
    miDebuggerServerAddress = 'localhost:7777',
    cwd = vim.fn.getcwd(),
  },
  setmetatable({
    name = 'nvim - Launch Full, Debug Server',
    type = 'cppdbg',
    request = 'launch',
    program = function()
      return vim.fn.getcwd() .. '/build/bin/nvim'
    end,
    externalConsole = true,
    cwd = '.',
  }, {
    __call = function(config)
      local key = 'gf_nvim_launch_full_debug_server'
      dap.listeners.after.initialize[key] = function(session)
        dap.listeners.after.initialize[key] = nil
        session.on_close[key] = function()
          for _, handler in pairs(dap.listeners.after) do
            handler[key] = nil
          end
        end
      end

      dap.listeners.after.event_process[key] = function(_, body)
        dap.listeners.after.event_process[key] = nil

        local ppid = body.systemProcessId

        vim.wait(1000, function()
          return tonumber(vim.fn.system('ps -o pid= --ppid ' .. tostring(ppid))) ~= nil
        end)
        local pid = tonumber(vim.fn.system('ps -o pid= --ppid ' .. tostring(ppid)))
        assert(pid ~= nil, 'child process ID should not be nil')

        if pid then
          dap.run({
            name = 'Neovim embedded',
            type = 'cppdbg',
            request = 'attach',
            processId = pid,
            program = vim.fn.getcwd() .. '/build/bin/nvim',
            cwd = vim.fn.getcwd(),
            externalConsole = true,
          })
        end
      end
      return config
    end,
  }),
  {
    name = 'nvim - Launch Headless',
    type = 'cppdbg',
    request = 'launch',
    program = function()
      return vim.fn.getcwd() .. '/build/bin/nvim'
    end,
    args = { '--headless', '--listen', 'localhost:7777' },
    externalConsole = true,
    cwd = vim.fn.getcwd(),
  },
  {
    name = 'nvim - Attach Tests',
    type = 'cppdbg',
    request = 'launch',
    program = function()
      return vim.fn.getcwd() .. '/build/bin/nvim'
    end,
    miDebuggerServerAddress = 'localhost:7777',
    cwd = vim.fn.getcwd(),
  },
}

local function session_active()
  local session = dap.session()
  if session and not session.closed then
    return session
  end
  print('No nvim-dap session active.')
  return nil
end

local dap_ui = require 'dap.ui.widgets'

local set = vim.keymap.set

set('n', '<leader>dc', function()
  dap.continue()
end)

set({ 'n', 'v' }, '<C-k>', function()
  if session_active() then
    dap_ui.hover()
  end
end)

set('n', '<leader>dC', function()
  if session_active() then
    dap.run_to_cursor()
  end
end)

set('n', '<leader>dk', function()
  if session_active() then
    dap.up()
  end
end)

set('n', '<leader>dj', function()
  if session_active() then
    dap.down()
  end
end)

set('n', '<leader>dn', function()
  if session_active() then
    dap.step_over()
  end
end)

set('n', '<leader>bb', function()
  dap.toggle_breakpoint()
end)

set('n', '<leader>bc', function()
  dap.clear_breakpoints()
end)

--- Dap View
local dap_view = require('dap-view')

dap_view.setup({
  winbar = {
    sections = { 'watches', 'scopes', 'exceptions', 'breakpoints', 'threads', 'repl', 'console' },
  },
  switchbuf = 'uselast,useopen',
})

set('n', '<leader>dv', function()
  dap_view.toggle()
end)
