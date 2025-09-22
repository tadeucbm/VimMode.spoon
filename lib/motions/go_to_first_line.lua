local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")

local GoToFirstLine = Motion:new{ name = 'go_to_first_line' }

function GoToFirstLine.getRange(_, buffer, _, repeatTimes)
  return {
    start = buffer:getCaretPosition(),
    finish = 0,
    mode = 'linewise',
    direction = 'characterwise'
  }
end

return GoToFirstLine