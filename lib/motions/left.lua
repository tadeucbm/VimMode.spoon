local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")

local Left = Motion:new{ name = 'left' }

function Left.getRange(_, buffer, operator, repeatTimes)
  repeatTimes = repeatTimes or 1
  
  local success, start = pcall(function() return buffer:getCaretPosition() end)
  if not success then return nil end
  
  -- Get current line information to respect line boundaries
  local success2, lineRange = pcall(function() return buffer:getCurrentLineRange() end)
  if not success2 then
    -- Fallback: simple character movement without line boundary checking
    return {
      start = math.max(0, start - repeatTimes),
      finish = start,
      mode = 'exclusive',
      direction = 'characterwise'
    }
  end
  
  local positionInLine = start - lineRange.location
  
  -- Calculate max possible movement within the current line
  local maxMovement = positionInLine
  local actualMovement = math.min(repeatTimes, maxMovement)

  return {
    start = start - actualMovement,
    finish = start,
    mode = 'exclusive',
    direction = 'characterwise'
  }
end

function Left.getMovements()
  return {
    {
      modifiers = {},
      key = 'left',
      selection = true
    }
  }
end

return Left
