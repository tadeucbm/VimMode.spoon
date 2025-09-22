local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")

local Up = Motion:new{ name = 'up' }

function Up.getRange(_, buffer, operator, repeatTimes)
  repeatTimes = repeatTimes or 1
  
  local success, lineNum = pcall(function() return buffer:getCurrentLineNumber() end)
  if not success or lineNum == 1 then return nil end

  local success2, column = pcall(function() return buffer:getCurrentColumn() end)
  if not success2 then return nil end
  
  -- Calculate target line based on repeat times, but don't go before line 1
  local targetLine = math.max(lineNum - repeatTimes, 1)
  
  local success3, start = pcall(function() return buffer:getPositionForLineAndColumn(targetLine, column) end)
  if not success3 then return nil end
  
  local success4, finish = pcall(function() return buffer:getCaretPosition() end)
  if not success4 then return nil end

  return {
    start = start,
    finish = finish,
    mode = 'exclusive',
    direction = 'linewise'
  }
end

function Up.getMovements()
  return {
    {
      modifiers = {},
      key = 'up',
      selection = true
    }
  }
end

return Up
