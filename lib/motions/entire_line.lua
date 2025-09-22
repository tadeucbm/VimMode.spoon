local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")

local EntireLine = Motion:new{ name = 'entire_line' }

function EntireLine.getRange(_, buffer, operator, repeatTimes)
  repeatTimes = repeatTimes or 1
  
  local lineRange = buffer:getCurrentLineRange()
  local start = lineRange.location

  if buffer:isOnLastLine() and buffer:charAt(start - 1) == "\n" then
    -- delete upwards from the last line and remove the trailing \n
    start = start - 1
  end

  -- For multiple lines, extend the range to include additional lines
  local finish = lineRange:positionEnd()
  
  if repeatTimes > 1 then
    -- Get the current line number and calculate target line
    local currentLine = buffer:getCurrentLineNumber()
    local targetLine = math.min(currentLine + repeatTimes - 1, buffer:getLineCount())
    
    -- Get the range for the target line
    local targetLineRange = buffer:getRangeForLineNumber(targetLine)
    finish = targetLineRange:positionEnd()
  end

  return {
    start = math.max(start, 0),
    finish = finish,
    mode = 'exclusive',
    direction = 'linewise'
  }
end

function EntireLine.getMovements()
  return {
    {
      modifiers = { 'cmd' },
      key = 'left'
    },
    {
      modifiers = { 'cmd' },
      key = 'right',
      selection = true
    }
  }
end

return EntireLine
