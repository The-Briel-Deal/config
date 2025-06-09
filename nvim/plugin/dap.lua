local dap = require('dap') ---@module 'nvim-dap.lua.dap'
local assert = require('luassert')

dap.defaults.fallback.external_terminal = {
  command = 'tmux',
  args = { 'splitw' },
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

local set = vim.keymap.set

set('n', '<leader>dc', function()
  dap.continue()
end)

set('n', '<leader>dC', function()
  if session_active() then
    dap.run_to_cursor()
  end
end)

---@param fields table
---@param session dap.Session
---@param variable_reference integer
---@return table
local function recurse_fields(fields, session, variable_reference)
  local err, res = session:request('variables', { variablesReference = variable_reference })
  assert.Nil(err)
  assert(res)
  for _, variable in ipairs(res.variables) do
    if variable.variablesReference > 0 then
      fields[variable.name] = {}
      recurse_fields(fields[variable.name], session, variable.variablesReference)
    else
      fields[variable.name] = variable.value
    end
  end
  return fields
end

---	@type integer|nil
local cur_win = nil
set({ 'n', 'v' }, '<C-k>', function()
  if cur_win then
    vim.api.nvim_set_current_win(cur_win)
    return
  end
  local session = session_active()
  if session then
    local expr_under_cursor = vim.fn.expand('<cexpr>')
    session:evaluate(
      { expression = expr_under_cursor, context = 'hover' },
      function(eva_err, eva_res)
        if eva_err then
          print(
            "DAP - Could not evaluate '"
              .. expr_under_cursor
              .. (eva_err.body.error and ("': '" .. eva_err.body.error.format .. "'") or "'.")
          )
          return
        end

        assert.not_nil(eva_res)

        local buf = vim.api.nvim_create_buf(false, true)
        local ns = vim.api.nvim_create_namespace('dbg_float')

        local cur_line = 0

        local header = (eva_res.type or '') .. ' ' .. expr_under_cursor
        if type(header) == 'string' then
          local end_col = #header
          vim.api.nvim_buf_set_lines(buf, cur_line, cur_line, true, { header })
          vim.api.nvim_buf_set_extmark(
            buf,
            ns,
            cur_line,
            0,
            { end_col = end_col, end_line = cur_line, hl_group = 'Title' }
          )
          cur_line = cur_line + 1

          vim.api.nvim_buf_set_lines(buf, cur_line, cur_line, true, { '' })
          cur_line = cur_line + 1
        end

        for line in string.gmatch(eva_res.result, '[^\n^\r]*') do
          local end_col = #line
          vim.api.nvim_buf_set_lines(buf, cur_line, cur_line, true, { line })
          vim.api.nvim_buf_set_extmark(
            buf,
            ns,
            cur_line,
            0,
            { end_col = end_col, end_line = cur_line, hl_group = 'NormalFloat' }
          )
          cur_line = cur_line + 1
        end

        local vars = {}

        local variables = recurse_fields(vars, session, eva_res.variablesReference)

        local vars_str = vim.inspect(variables)

        for line in string.gmatch(vars_str, '[^\n^\r]*') do
          local end_col = #line
          vim.api.nvim_buf_set_lines(buf, cur_line, cur_line, true, { line })
          vim.api.nvim_buf_set_extmark(
            buf,
            ns,
            cur_line,
            0,
            { end_col = end_col, end_line = cur_line, hl_group = 'NormalFloat' }
          )
          cur_line = cur_line + 1
        end

        assert.Nil(cur_win)
        cur_win = vim.api.nvim_open_win(buf, false, {
          relative = 'cursor',
          border = 'rounded',
          row = 2,
          col = 2,
          width = 40,
          height = 10,
          style = 'minimal',
          title = 'DBG - ' .. expr_under_cursor,
        })
        local closed_float = false
        local close_float = function()
          if closed_float then
            return
          end
          vim.api.nvim_win_close(cur_win, false)
          cur_win = nil
          closed_float = true
        end
        vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
          callback = close_float,
          once = true,
          buffer = 0,
        })
        vim.keymap.set('n', 'q', close_float, { buffer = buf })
      end
    )
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
