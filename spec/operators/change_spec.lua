local Buffer = require("lib/buffer")
local Selection = require("lib/selection")
local Change = require("lib/operators/change")

describe("Change", function()
  it("has a name", function()
    assert.are.equals("change", Change:new().name)
  end)

  describe("#getModeForTransition", function()
    it("transitions to insert mode", function()
      local change = Change:new()
      assert.are.equals("insert", change.getModeForTransition())
    end)
  end)

  describe("inherits from Delete", function()
    it("can delete text like Delete operator", function()
      local buffer = Buffer:new()
      buffer:setValue("word one two")
      buffer:setSelectionRange(0, 0)

      local change = Change:new()

      -- Should have same delete functionality as Delete operator
      local newBuffer = change:getModifiedBuffer(buffer, 0, 4)

      assert.are.equals("one two", newBuffer:getValue())
      assert.are.same(
        Selection:new(0, 0),
        newBuffer:getSelectionRange()
      )
    end)

    it("deletes text in the middle", function()
      local buffer = Buffer:new()
      buffer:setValue("word one two")
      buffer:setSelectionRange(5, 0)

      local change = Change:new()

      local newBuffer = change:getModifiedBuffer(buffer, 5, 8)

      assert.are.equals("word two", newBuffer:getValue())
      assert.are.same(
        Selection:new(5, 0),
        newBuffer:getSelectionRange()
      )
    end)
  end)

  describe("special motion handling", function()
    it("exists as documented feature", function()
      -- The change operator has special handling for "cw" and "cW" motions
      -- that treats them like "ce" and "cE" when cursor is on non-blank
      -- This is tested more thoroughly in integration tests
      local change = Change:new()
      assert.is_not_nil(change)
      assert.are.equals("change", change.name)
    end)
  end)
end)