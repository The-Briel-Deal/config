--- @class FloatWin: FloatBase

--- @class NewFloatOpts
--- @field height integer
--- @field width integer
--- @field title string
--- @field body string

--- @class FloatWinMod
--- @field New fun(opts: NewFloatOpts): FloatWin
---
local M = {}

--- @class FloatBase
--- @field height integer
--- @field width integer
--- @field title string
--- @field body string
--- @field win integer
--- @field buf integer
--- @field ns integer
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

function FloatBase:close_float()
  vim.api.nvim_win_close(self.win, false)
end

function M.New(opts)
  local buf = vim.api.nvim_create_buf(false, true)
  local ns = vim.api.nvim_create_namespace('dbg_float')
  local o = {
    height = opts.height,
    width = opts.width,
    title = opts.title,
    body = opts.body,
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

  vim.api.nvim_create_autocmd({ 'CursorMoved' }, {
    callback = function()
      o:close_float()
    end,
    once = true,
    buffer = 0,
  })

  return o
end

return M
