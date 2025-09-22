local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")

local Right = Motion:new{ name = 'right' }

function Right.getRange(_, buffer, operator, repeatTimes)
  repeatTimes = repeatTimes or 1
  
  local success, start = pcall(function() return buffer:getCaretPosition() end)
  if not success then return nil end
  
  local success2, bufferLength = pcall(function() return buffer:getLength() end)
  if not success2 then return nil end
  
  -- Get current line information to respect line boundaries
  local success3, currentLine = pcall(function() return buffer:getCurrentLine() end)
  if not success3 or not currentLine then
    -- Fallback: simple character movement without line boundary checking
    return {
      start = start,
      finish = math.min(start + repeatTimes, bufferLength - 1),
      mode = 'exclusive',
      direction = 'characterwise'
    }
  end
  
  local success4, lineRange = pcall(function() return buffer:getCurrentLineRange() end)
  if not success4 then return nil end
  
  local positionInLine = start - lineRange.location
  local lineLength = #currentLine
  
  -- Handle newline at end of line
  if currentLine:sub(-1) == "\n" then
    lineLength = lineLength - 1
  end
  
  -- Calculate max possible movement within the current line
  local maxMovement = math.max(0, lineLength - positionInLine - 1)
  local actualMovement = math.min(repeatTimes, maxMovement)
  
  return {
    start = start,
    finish = start + actualMovement,
    mode = 'exclusive',
    direction = 'characterwise'
  }
end

function Right.getMovements()
  return {
    {
      modifiers = {},
      key = 'right',
      selection = true
    }
  }
end

return Right
