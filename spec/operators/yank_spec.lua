local Buffer = require("lib/buffer")
local Selection = require("lib/selection")
local Yank = require("lib/operators/yank")

describe("Yank", function()
  it("has a name", function()
    assert.are.equals("yank", Yank:new().name)
  end)

  describe("#getModifiedBuffer", function()
    it("returns the original buffer unchanged", function()
      local buffer = Buffer:new()
      buffer:setValue("word one two")
      buffer:setSelectionRange(0, 0)

      local yank = Yank:new()
      local newBuffer = yank:getModifiedBuffer(buffer, 0, 4)

      -- Buffer should be unchanged
      assert.are.equals(buffer, newBuffer)
      assert.are.equals("word one two", newBuffer:getValue())
      assert.are.same(
        Selection:new(0, 0),
        newBuffer:getSelectionRange()
      )
    end)

    it("handles different ranges without modifying buffer", function()
      local buffer = Buffer:new()
      buffer:setValue("hello world test")
      buffer:setSelectionRange(6, 0)

      local yank = Yank:new()
      local newBuffer = yank:getModifiedBuffer(buffer, 6, 11)

      -- Buffer should remain exactly the same
      assert.are.equals(buffer, newBuffer)
      assert.are.equals("hello world test", newBuffer:getValue())
    end)
  end)

  describe("#getKeys", function()
    it("returns copy command for fallback mode", function()
      local yank = Yank:new()
      local keys = yank.getKeys()
      
      assert.is_table(keys)
      assert.are.equals(1, #keys)
      assert.are.same({'cmd'}, keys[1].modifiers)
      assert.are.equals('c', keys[1].key)
    end)
  end)

  describe("pasteboard operations", function()
    it("exists for pasteboard integration", function()
      -- Note: We can't easily test hs.pasteboard operations in unit tests
      -- since they require Hammerspoon environment. This test just ensures
      -- the yank operator structure is correct.
      local yank = Yank:new()
      assert.is_function(yank.modifySelection)
      assert.is_function(yank.getModifiedBuffer)
      assert.is_function(yank.getKeys)
    end)
  end)
end)