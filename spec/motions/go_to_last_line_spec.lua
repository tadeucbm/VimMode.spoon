local Buffer = dofile(vimModeScriptPath .. "lib/buffer.lua")
local GoToLastLine = dofile(vimModeScriptPath .. "lib/motions/go_to_last_line.lua")

describe("motion: go to last line", function()
  it("should move the cursor to the last line", function()
    local buffer = Buffer:new()
    buffer:setValue("hello\nworld\nagain")
    buffer:setCaretPosition(0)

    local range = GoToLastLine:getRange(buffer)

    assert.are.same({ start = 0, finish = 12, mode = "linewise", direction = "characterwise" }, range)
  end)
end)
