local t = require('util.testutil')
local n = require('util.testnvim')()
local Screen = require('util.screen')
local clear = n.clear
local feed = n.feed

describe('Testing busted', function()
  it('should work', function()
    clear()
    local screen = Screen.new(20, 10)
    feed('ihello world')
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
