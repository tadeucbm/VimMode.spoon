local Buffer = dofile((vimModeScriptPath or "") .. "lib/buffer.lua")
local ParagraphBackward = dofile((vimModeScriptPath or "") .. "lib/motions/paragraph_backward.lua")

describe("motion: paragraph backward", function()
  it("should move to beginning of previous paragraph", function()
    local buffer = Buffer:new()
    buffer:setValue("para1\n\npara2\nline2")
    buffer:setCaretPosition(10) -- middle of para2
    
    local range = ParagraphBackward:getRange(buffer)
    
    assert.are.same({ start = 10, finish = 6, mode = "exclusive", direction = "characterwise" }, range)
  end)

  it("should move to beginning of current paragraph if in middle", function()
    local buffer = Buffer:new()
    buffer:setValue("para1\nline2\n\npara2")
    buffer:setCaretPosition(8) -- middle of first paragraph
    
    local range = ParagraphBackward:getRange(buffer)
    
    assert.are.same({ start = 8, finish = 0, mode = "exclusive", direction = "characterwise" }, range)
  end)

  it("should stay at beginning if already there", function()
    local buffer = Buffer:new()
    buffer:setValue("para1\nline2")
    buffer:setCaretPosition(0)
    
    local range = ParagraphBackward:getRange(buffer)
    
    assert.are.same({ start = 0, finish = 0, mode = "exclusive", direction = "characterwise" }, range)
  end)

  it("should handle multiple paragraph jumps", function()
    local buffer = Buffer:new()
    buffer:setValue("para1\n\npara2\n\npara3")
    buffer:setCaretPosition(16) -- in para3
    
    local range = ParagraphBackward:getRange(buffer, nil, 2)
    
    assert.are.same({ start = 16, finish = 0, mode = "exclusive", direction = "characterwise" }, range)
  end)
end)