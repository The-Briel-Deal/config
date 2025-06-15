local t = require('util.testutil')
local n = require('util.testnvim')()
local Screen = require('util.screen')
local clear = n.clear
local feed = n.feed
local exec_lua = n.exec_lua

describe('Floating window', function()
  it('appears', function()
    clear()
    local screen = Screen.new(20, 10)
		exec_lua(function()
			print('hello world')
		end)
    screen:add_extra_attr_ids({
      [101] = { foreground = Screen.colors.NvimLightGray4 },
      [102] = { foreground = Screen.colors.NvimDarkGreen },
    })

    screen:expect([[
      hello world^         |
      {101:~                   }|*8
      {102:-- INSERT --}        |
    ]])
  end)
end)
