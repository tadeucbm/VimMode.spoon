local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")
local stringUtils = dofile(vimModeScriptPath .. "lib/utils/string_utils.lua")

local ForwardSearch = Motion:new{ name = 'forward_search' }

function ForwardSearch:getRange(buffer, operator, repeatTimes)
  repeatTimes = repeatTimes or 1
  local start = buffer:getCaretPosition()
  local stringStart = start + 1
  local searchChar = self:getExtraChar()

  local success, result = pcall(function()
    local contents = buffer:getValue()
    if not contents then
      return nil
    end

    local nextOccurringIndex = stringStart
    
    for i = 1, repeatTimes do
      nextOccurringIndex = stringUtils.findNextIndex(
        contents,
        searchChar,
        nextOccurringIndex + 1 -- start from the next char
      )
      
      if not nextOccurringIndex then return nil end
    end

    return {
      start = start,
      finish = nextOccurringIndex - 1,
      mode = 'inclusive',
      direction = 'characterwise'
    }
  end)

  if not success then
    return nil
  end

  return result
end

function ForwardSearch.getMovements()
  return nil
end

return ForwardSearch
