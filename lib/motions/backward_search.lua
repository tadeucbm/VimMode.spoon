local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")
local stringUtils = dofile(vimModeScriptPath .. "lib/utils/string_utils.lua")

local BackwardSearch = Motion:new{ name = 'backward_search' }

function BackwardSearch:getRange(buffer, operator, repeatTimes)
  repeatTimes = repeatTimes or 1
  local finish = buffer:getCaretPosition()
  local stringFinish = finish + 1
  local searchChar = self:getExtraChar()

  local success, result = pcall(function()
    local contents = buffer:getValue()
    if not contents then
      return nil
    end

    local prevOccurringIndex = stringFinish
    
    for i = 1, repeatTimes do
      prevOccurringIndex = stringUtils.findPrevIndex(
        contents,
        searchChar,
        prevOccurringIndex - 1 -- start from the prev char
      )
      
      if not prevOccurringIndex then return nil end
    end

    return {
      start = prevOccurringIndex - 1,
      finish = finish,
      mode = 'exclusive',
      direction = 'characterwise'
    }
  end)

  if not success then
    return nil
  end

  return result
end

function BackwardSearch.getMovements()
  return nil
end

return BackwardSearch
