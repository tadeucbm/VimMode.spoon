local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")

local LineBeginning = Motion:new{ name = 'line_beginning' }

function LineBeginning.getRange(_, buffer, operator, repeatTimes)
  repeatTimes = repeatTimes or 1
  
  local currentLine = buffer:getCurrentLineNumber()
  local targetLine = currentLine + repeatTimes - 1
  
  -- Get the beginning of the target line
  local targetLineRange = buffer:getRangeForLineNumber(targetLine)

  return {
    start = targetLineRange.location,
    finish = buffer:getCaretPosition(),
    mode = 'exclusive',
    direction = 'characterwise'
  }
end

function LineBeginning.getMovements()
  return {
    {
      modifiers = { 'ctrl' },
      key = 'a',
      selection = true
    }
  }
end

return LineBeginning
