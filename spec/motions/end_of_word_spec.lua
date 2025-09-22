local Buffer = dofile(vimModeScriptPath .. "lib/buffer.lua")
local EndOfWord = dofile(vimModeScriptPath .. "lib/motions/end_of_word.lua")

describe("motion: end of word", function()
  it("should move the cursor to the end of the current word", function()
    local buffer = Buffer:new()
    buffer:setValue("hello world")
    buffer:setCaretPosition(0)

    local range = EndOfWord:getRange(buffer)

    assert.are.same({ start = 0, finish = 4, mode = "inclusive", direction = "characterwise" }, range)
  end)

  it("should move the cursor to the end of the next word if at the end of a word", function()
    local buffer = Buffer:new()
    buffer:setValue("hello world")
    buffer:setCaretPosition(4)

    local range = EndOfWord:getRange(buffer)

    assert.are.same({ start = 4, finish = 10, mode = "inclusive", direction = "characterwise" }, range)
  end)

  it("should handle multiple word jumps", function()
    local buffer = Buffer:new()
    buffer:setValue("hello world again")
    buffer:setCaretPosition(0)

    local range = EndOfWord:getRange(buffer, nil, 2)

    assert.are.same({ start = 0, finish = 10, mode = "inclusive", direction = "characterwise" }, range)
  end)

  it("should stop at the end of the buffer", function()
    local buffer = Buffer:new()
    buffer:setValue("hello world")
    buffer:setCaretPosition(8)

    local range = EndOfWord:getRange(buffer, nil, 2)

    assert.are.same({ start = 8, finish = 10, mode = "inclusive", direction = "characterwise" }, range)
  end)
end)