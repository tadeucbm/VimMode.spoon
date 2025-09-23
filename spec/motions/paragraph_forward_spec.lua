local Buffer = dofile((vimModeScriptPath or "") .. "lib/buffer.lua")
local ParagraphForward = dofile((vimModeScriptPath or "") .. "lib/motions/paragraph_forward.lua")

describe("motion: paragraph forward", function()
  it("should move to end of next paragraph", function()
    local buffer = Buffer:new()
    buffer:setValue("para1\n\npara2\nline2")
    buffer:setCaretPosition(2) -- middle of para1
    
    local range = ParagraphForward:getRange(buffer)
    
    assert.are.same({ start = 2, finish = 5, mode = "exclusive", direction = "characterwise" }, range)
  end)

  it("should move to end of current paragraph if in middle", function()
    local buffer = Buffer:new()
    buffer:setValue("para1\nline2\n\npara2")
    buffer:setCaretPosition(3) -- middle of first paragraph
    
    local range = ParagraphForward:getRange(buffer)
    
    assert.are.same({ start = 3, finish = 11, mode = "exclusive", direction = "characterwise" }, range)
  end)

  it("should stay at end if already there", function()
    local buffer = Buffer:new()
    buffer:setValue("para1\nline2")
    buffer:setCaretPosition(11) -- at end
    
    local range = ParagraphForward:getRange(buffer)
    
    assert.are.same({ start = 11, finish = 11, mode = "exclusive", direction = "characterwise" }, range)
  end)

  it("should handle multiple paragraph jumps", function()
    local buffer = Buffer:new()
    buffer:setValue("para1\n\npara2\n\npara3")
    buffer:setCaretPosition(2) -- in para1
    
    local range = ParagraphForward:getRange(buffer, nil, 2)
    
    assert.are.same({ start = 2, finish = 16, mode = "exclusive", direction = "characterwise" }, range)
  end)
end)