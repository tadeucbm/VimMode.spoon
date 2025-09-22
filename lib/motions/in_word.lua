local BackWord = dofile(vimModeScriptPath .. "lib/motions/back_word.lua")
local EndOfWord = dofile(vimModeScriptPath .. "lib/motions/end_of_word.lua")

local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")
local stringUtils = dofile(vimModeScriptPath .. "lib/utils/string_utils.lua")
local utf8 = dofile(vimModeScriptPath .. "vendor/luautf8.lua")

local InWord = Motion:new{ name = 'in_word' }

function InWord:getRange(buffer, operator, repeatTimes)
  repeatTimes = repeatTimes or 1
  
  local success, result = pcall(function()
    local start = buffer:getCaretPosition()
    local finish = start

    local atBeginning = stringUtils.isWordBoundary(buffer:prevChar())

    if not atBeginning then
      local beginningOfWord = BackWord:new()
      local startRange = beginningOfWord:getRange(buffer, operator, repeatTimes)

      start = startRange.start
    end

    local atEnd = stringUtils.isWordBoundary(buffer:nextChar())

    if not atEnd then
      local endOfWord = EndOfWord:new()
      local endRange = endOfWord:getRange(buffer, operator, repeatTimes)

      finish = endRange.finish
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
