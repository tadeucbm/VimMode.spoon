local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")

local CurrentSelection = Motion:new{ name = 'current_selection' }

function CurrentSelection.getRange(_, buffer, operator, repeatTimes)
  repeatTimes = repeatTimes or 1
  
  local success, result = pcall(function()
    local selection = buffer:getSelectionRange()

    return {
      start = selection.location,
      finish = selection:positionEnd(),
      mode = 'inclusive',
      direction = 'characterwise'
    }
  end)

  if not success then
    return {
      start = 0,
      finish = 0,
      mode = 'inclusive',
      direction = 'characterwise'
    }
  end

  return result
end

function CurrentSelection.getMovements()
  return {}
end

return CurrentSelection
