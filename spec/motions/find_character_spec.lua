local Buffer = dofile(vimModeScriptPath .. "lib/buffer.lua")
local FindCharacter = dofile(vimModeScriptPath .. "lib/motions/find_character.lua")

describe("motion: find character", function()
  it("should move the cursor to the next occurrence of a character on the current line", function()
    local buffer = Buffer:new()
    buffer:setValue("hello world")
    buffer:setCaretPosition(0)

    local range = FindCharacter:getRange(buffer, { char = "o" })

    assert.are.same({ start = 0, finish = 4, mode = "inclusive", direction = "characterwise" }, range)
  end)

  it("should not move the cursor if the character is not found", function()
    local buffer = Buffer:new()
    buffer:setValue("hello world")
    buffer:setCaretPosition(0)

    local range = FindCharacter:getRange(buffer, { char = "z" })

    assert.are.same({ start = 0, finish = 0, mode = "inclusive", direction = "characterwise" }, range)
  end)
end)