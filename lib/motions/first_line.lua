local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")

local FirstLine = Motion:new{ name = 'first_line' }

function FirstLine.getRange(_, buffer, operator, repeatTimes)
  repeatTimes = repeatTimes or 1
  
  local success, result = pcall(function()
    local finish = buffer:getCurrentLineRange():positionEnd()

    return {
      start = 0,
      finish = finish,
      mode = 'exclusive',
      direction = 'linewise'
    }
  end)

  if not success then
    return {
      start = 0,
      finish = 0,
      mode = 'exclusive',
      direction = 'linewise'
    }
  end

  return result
end

function FirstLine.getMovements()
  return {
    {
      modifiers = {'cmd'},
      key = 'up',
      selection = true
    },
    {
      modifiers = {'ctrl'},
      key = 'a',
      selection = true
    }
  }
end

return FirstLine
