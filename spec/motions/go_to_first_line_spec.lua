local Buffer = dofile(vimModeScriptPath .. "lib/buffer.lua")
local GoToFirstLine = dofile(vimModeScriptPath .. "lib/motions/go_to_first_line.lua")

describe("motion: go to first line", function()
  it("should move the cursor to the first line", function()
    local buffer = Buffer:new()
    buffer:setValue("hello\nworld\nagain")
    buffer:setCaretPosition(10)

    local range = GoToFirstLine:getRange(buffer)

    assert.are.same({ start = 10, finish = 0, mode = "linewise", direction = "characterwise" }, range)
  end)
end)
