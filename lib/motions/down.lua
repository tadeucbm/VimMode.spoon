local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")

local Down = Motion:new{ name = 'down' }

function Down.getRange(_, buffer, operator, repeatTimes)
  repeatTimes = repeatTimes or 1
  
  -- Handle cases where buffer content is not accessible
  local success, isOnLastLine = pcall(function() return buffer:isOnLastLine() end)
  if not success or isOnLastLine then return nil end

  local success2, lineNum = pcall(function() return buffer:getCurrentLineNumber() end)
  if not success2 then return nil end
  
  local success3, column = pcall(function() return buffer:getCurrentColumn() end)
  if not success3 then return nil end
  
  local success4, lineCount = pcall(function() return buffer:getLineCount() end)
  if not success4 then return nil end
  
  -- Calculate target line based on repeat times, but don't go past last line
  local targetLine = math.min(lineNum + repeatTimes, lineCount)
  
  local success5, finish = pcall(function() return buffer:getPositionForLineAndColumn(targetLine, column) end)
  if not success5 then return nil end

  local success6, start = pcall(function() return buffer:getCaretPosition() end)
  if not success6 then return nil end

  return {
    start = start,
    finish = finish,
    mode = 'exclusive',
    direction = 'linewise'
  }
end

function Down.getMovements()
  return {
    {
      modifiers = {},
      key = 'down',
      selection = true
    }
  }
end

return Down
