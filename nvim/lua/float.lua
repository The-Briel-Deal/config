--- @class FloatWin: FloatBase

--- @class NewFloatOpts
--- @field height integer
--- @field width integer
--- @field title string
--- @field body string
--- @field focus_key string?

--- @class FloatWinMod
--- @field New fun(opts: NewFloatOpts): FloatWin
---
local M = {}

--- @class FloatBase
--- @field height integer
--- @field width integer
--- @field title string
--- @field body string
--- @field focus_key string?
--- @field win integer
--- @field lower_buf integer
--- @field buf integer
--- @field ns integer
--- @field autocmd_id integer?
---
local FloatBase = {
  height = 20,
  width = 20,
  title = 'default',
  body = 'FloatBase default body',
  win = -1,
  buf = -1,
  ns = -1,
}

function FloatBase:sync_body()
  local cur_line = 0
  for line in string.gmatch(self.body, '[^\n^\r]*') do
    local end_col = #line
    vim.api.nvim_buf_set_lines(self.buf, cur_line, cur_line, true, { line })
    vim.api.nvim_buf_set_extmark(
      self.buf,
      self.ns,
      cur_line,
      0,
      { end_col = end_col, end_line = cur_line, hl_group = 'NormalFloat' }
    )
    cur_line = cur_line + 1
  end
end

function FloatBase:close()
  vim.api.nvim_win_close(self.win, false)
  if self.autocmd_id then
    vim.api.nvim_del_autocmd(self.autocmd_id)
    self.autocmd_id = nil
  end
  if self.focus_key then
    vim.keymap.del('n', self.focus_key, { buffer = self.lower_buf })
  end
end

function FloatBase:focus()
  vim.api.nvim_set_current_win(self.win)
end

function M.New(opts)
  local buf = vim.api.nvim_create_buf(false, true)
  local ns = vim.api.nvim_create_namespace('dbg_float')
  local o = {
    height = opts.height,
    width = opts.width,
    title = opts.title,
    body = opts.body,
    focus_key = opts.focus_key,
    autocmd_id = nil,
    lower_buf = vim.api.nvim_get_current_buf(),
    buf = buf,
    ns = ns,
  }
  setmetatable(o, { __index = FloatBase })
  --- @cast o FloatWin
  o:sync_body()
  o.win = vim.api.nvim_open_win(buf, false, {
    title = opts.title,
    height = opts.height,
    width = opts.width,
    row = 1,
    col = 1,
    relative = 'cursor',
    border = 'rounded',
    style = 'minimal',
  })

  o.autocmd_id = vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
    callback = function()
      o:close()
    end,
    once = true,
    buffer = o.lower_buf,
  })

  if opts.focus_key then
    vim.keymap.set('n', opts.focus_key, function()
      o:focus()
    end, { buffer = o.lower_buf })
  end

  vim.keymap.set('n', 'q', function()
    o:close()
  end, { buffer = buf })

  return o
end

return M
