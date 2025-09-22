local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")

local GoToLastLine = Motion:new{ name = 'go_to_last_line' }

function GoToLastLine.getRange(_, buffer, _, repeatTimes)
  local contents = buffer:getValue()
  local lastNewLine = 0
  for i = #contents, 1, -1 do
    if string.sub(contents, i, i) == "\n" then
      lastNewLine = i
      break
    end
  end

  return {
    start = buffer:getCaretPosition(),
    finish = lastNewLine,
    mode = 'linewise',
    direction = 'characterwise'
  }
end

return GoToLastLine

