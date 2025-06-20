local float = require('float')
local dap = require('dap') ---@module 'nvim-dap.lua.dap'
local dap_ui = require 'dap.ui'
local dap_ui_widgets = require 'dap.ui.widgets'
local dap_virt_text = require('nvim-dap-virtual-text')
local assert = require('luassert') ---@module 'luassert'

local api = vim.api
local set = vim.keymap.set

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

dap_virt_text.setup({}) ---@diagnostic disable-line

local function session_active()
  local session = dap.session()
  if session and not session.closed then
    return session
  end
  print('No nvim-dap session active.')
  return nil
end

---@param expr nil|string|fun():string
---@return string
local function eval_expression(expr)
  local mode = api.nvim_get_mode()
  if mode.mode == 'v' then
    -- [bufnum, lnum, col, off]; 1-indexed
    local start = vim.fn.getpos('v')
    local end_ = vim.fn.getpos('.')

    local start_row = start[2]
    local start_col = start[3]

    local end_row = end_[2]
    local end_col = end_[3]

    if start_row == end_row and end_col < start_col then
      end_col, start_col = start_col, end_col
    elseif end_row < start_row then
      start_row, end_row = end_row, start_row
      start_col, end_col = end_col, start_col
    end

    api.nvim_feedkeys(api.nvim_replace_termcodes('<ESC>', true, false, true), 'n', false)

    -- buf_get_text is 0-indexed; end-col is exclusive
    local lines = api.nvim_buf_get_text(0, start_row - 1, start_col - 1, end_row - 1, end_col, {})
    return table.concat(lines, '\n')
  end
  expr = expr or '<cexpr>'
  if type(expr) == 'function' then
    return expr()
  else
    return vim.fn.expand(expr)
  end
end

local function with_winopts(new_win, winopts)
  return function(...)
    local win = new_win(...)
    dap_ui.apply_winopts(win, winopts)
    return win
  end
end

---@param expr nil|string|fun():string
---@param winopts table<string, any>?
local function hover(expr, winopts)
  local value = eval_expression(expr)
  local view = dap_ui_widgets
    .builder(dap_ui_widgets.expression)
    .new_win(dap_ui_widgets.with_resize(with_winopts(function()
      local floatingWin =
        float.New({ focus_key = '<C-k>', height = 30, width = 20, body = '', title = 'dbg' })
      return floatingWin.win
    end, winopts)))
    .build()
  local buf = view.open(value)
  api.nvim_buf_set_name(buf, 'dap-hover-' .. tostring(buf) .. ': ' .. value)
  api.nvim_win_set_cursor(view.win, { 1, 0 })
  return view
end

local winopts = { border = 'rounded' }

set({ 'n', 'v' }, '<C-k>', function()
  if session_active() then
    hover(nil, winopts)
  end
end)

set('n', '<A-S-c>', function()
  dap.continue()
end)

set('n', '<A-c>', function()
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
