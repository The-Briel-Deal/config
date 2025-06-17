local t = require('util.testutil')
local n = require('util.testnvim')()
local Screen = require('util.screen')
local clear = n.clear
local feed = n.feed
local exec_lua = n.exec_lua

describe('Floating window', function()
  ---@type test.functional.ui.screen
  local screen

  before_each(function()
    clear()
    screen = Screen.new(20, 10)
  end)

  it('appears', function()
    exec_lua(function()
      local float = require('float')
      float.New { title = 'foo', width = 10, height = 5, body = 'foo\nbar\nbaz' }
    end)
    screen:add_extra_attr_ids({
      [101] = { foreground = Screen.colors.NvimLightGray4 },
      [102] = { foreground = Screen.colors.NvimDarkGreen },
      [103] = { background = Screen.colors.NvimLightGrey1 },
      [104] = { foreground = Screen.colors.NvimDarkGrey2, bold = true },
    })

    screen:expect([[
      ^                    |
      {101:~}{103:╭}{104:foo}{103:───────╮}{101:       }|
      {101:~}{103:│foo       │}{101:       }|
      {101:~}{103:│          │}{101:       }|
      {101:~}{103:│bar       │}{101:       }|
      {101:~}{103:│          │}{101:       }|
      {101:~}{103:│baz       │}{101:       }|
      {101:~}{103:╰──────────╯}{101:       }|
      {101:~                   }|
                          |
    ]])
  end)

  it('disappears on cursor move', function()
    -- Buffer needs to have chars so I can move cursor.
    feed([[iabc<esc>0]])

    exec_lua(function()
      local float = require('float')
      float.New { title = 'foo', width = 10, height = 5, body = 'foo\nbar\nbaz' }
    end)

    screen:add_extra_attr_ids({
      [101] = { foreground = Screen.colors.NvimLightGray4 },
      [102] = { foreground = Screen.colors.NvimDarkGreen },
      [103] = { background = Screen.colors.NvimLightGrey1 },
      [104] = { foreground = Screen.colors.NvimDarkGrey2, bold = true },
    })

    screen:expect([[
      ^abc                 |
      {101:~}{103:╭}{104:foo}{103:───────╮}{101:       }|
      {101:~}{103:│foo       │}{101:       }|
      {101:~}{103:│          │}{101:       }|
      {101:~}{103:│bar       │}{101:       }|
      {101:~}{103:│          │}{101:       }|
      {101:~}{103:│baz       │}{101:       }|
      {101:~}{103:╰──────────╯}{101:       }|
      {101:~                   }|
                          |
    ]])

    feed([[l]])

    screen:expect([[
      a^bc                 |
      {101:~                   }|*8
                          |
    ]])
  end)

  it('does not error on window close', function()
    -- Buffer needs to have chars so I can move cursor.
    feed([[iabc<esc>0]])

    exec_lua(function()
      local float = require('float')
      float.New { title = 'foo', width = 10, height = 5, body = 'foo\nbar\nbaz', focus_key = '<C-k>' }
    end)

    screen:add_extra_attr_ids({
      [101] = { foreground = Screen.colors.NvimLightGray4 },
      [102] = { foreground = Screen.colors.NvimDarkGreen },
      [103] = { background = Screen.colors.NvimLightGrey1 },
      [104] = { foreground = Screen.colors.NvimDarkGrey2, bold = true },
    })

    screen:expect([[
      ^abc                 |
      {101:~}{103:╭}{104:foo}{103:───────╮}{101:       }|
      {101:~}{103:│foo       │}{101:       }|
      {101:~}{103:│          │}{101:       }|
      {101:~}{103:│bar       │}{101:       }|
      {101:~}{103:│          │}{101:       }|
      {101:~}{103:│baz       │}{101:       }|
      {101:~}{103:╰──────────╯}{101:       }|
      {101:~                   }|
                          |
    ]])

    feed([[<C-k>]])

    screen:expect([[
      abc                 |
      {101:~}{103:╭}{104:foo}{103:───────╮}{101:       }|
      {101:~}{103:│^foo       │}{101:       }|
      {101:~}{103:│          │}{101:       }|
      {101:~}{103:│bar       │}{101:       }|
      {101:~}{103:│          │}{101:       }|
      {101:~}{103:│baz       │}{101:       }|
      {101:~}{103:╰──────────╯}{101:       }|
      {101:~                   }|
                          |
    ]])
  end)
end)
