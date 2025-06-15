local t = require 'util.testutil'
local n = require 'util.testnvim'

describe('Testing busted', function()
  it('should work', function()
    assert.truthy('yes pwease')
  end)
end)
