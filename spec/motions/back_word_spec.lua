local Buffer = dofile(vimModeScriptPath .. "lib/buffer.lua")
local BackWord = dofile(vimModeScriptPath .. "lib/motions/back_word.lua")

describe("motion: back word", function()
  it("should move the cursor to the beginning of the previous word", function()
    local buffer = Buffer:new()
    buffer:setValue("hello world")
    buffer:setCaretPosition(10)

    local range = BackWord:getRange(buffer)

    assert.are.same({ start = 10, finish = 6, mode = "exclusive", direction = "characterwise" }, range)
  end)

  it("should move the cursor to the beginning of the current word if in the middle of a word", function()
    local buffer = Buffer:new()
    buffer:setValue("hello world")
    buffer:setCaretPosition(8)

    local range = BackWord:getRange(buffer)

    assert.are.same({ start = 8, finish = 6, mode = "exclusive", direction = "characterwise" }, range)
  end)

  it("should handle multiple word jumps", function()
    local buffer = Buffer:new()
    buffer:setValue("hello world again")
    buffer:setCaretPosition(16)

    local range = BackWord:getRange(buffer, nil, 2)

    assert.are.same({ start = 16, finish = 6, mode = "exclusive", direction = "characterwise" }, range)
  end)

  it("should stop at the beginning of the buffer", function()
    local buffer = Buffer:new()
    buffer:setValue("hello world")
    buffer:setCaretPosition(2)

    local range = BackWord:getRange(buffer)

    assert.are.same({ start = 2, finish = 0, mode = "exclusive", direction = "characterwise" }, range)
  end)
end)