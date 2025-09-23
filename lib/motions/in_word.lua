local BackWord = dofile((vimModeScriptPath or "") .. "lib/motions/back_word.lua")
local EndOfWord = dofile((vimModeScriptPath or "") .. "lib/motions/end_of_word.lua")

local Motion = dofile((vimModeScriptPath or "") .. "lib/motion.lua")
local stringUtils = dofile((vimModeScriptPath or "") .. "lib/utils/string_utils.lua")
local utf8 = dofile((vimModeScriptPath or "") .. "vendor/luautf8.lua")

local InWord = Motion:new{ name = 'in_word' }

function InWord:getRange(buffer, operator, repeatTimes)
  repeatTimes = repeatTimes or 1
  
  local success, result = pcall(function()
    local currentPos = buffer:getCaretPosition()
    local contents = buffer:getValue()
    local length = buffer:getLength()
    
    -- If cursor is at end of buffer or on whitespace, return current position
    if currentPos >= length or stringUtils.isWordBoundary(utf8.sub(contents, currentPos + 1, currentPos + 1)) then
      return {
        start = currentPos,
        finish = currentPos,
        mode = 'inclusive',
        direction = 'characterwise',
      }
    end

    -- Find the start of the current word
    local start = currentPos
    while start > 0 do
      local char = utf8.sub(contents, start, start)
      if stringUtils.isWordBoundary(char) then
        break
      end
      start = start - 1
    end
    
    -- Find the end of the current word
    local finish = currentPos
    while finish < length - 1 do
      local nextChar = utf8.sub(contents, finish + 2, finish + 2)
      if stringUtils.isWordBoundary(nextChar) then
        break
      end
      finish = finish + 1
    end
    
    -- For inclusive motions, if we're at the end of buffer, extend to buffer length
    if finish == length - 1 then
      finish = length
    end

    return {
      start = start,
      finish = finish,
      mode = 'inclusive',
      direction = 'characterwise',
    }
  end)

  if not success then
    local start = buffer:getCaretPosition()
    return {
      start = start,
      finish = start,
      mode = 'inclusive',
      direction = 'characterwise',
    }
  end

  return result
end

function InWord.getMovements()
  return nil
end

return InWord
