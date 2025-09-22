local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")
local stringUtils = dofile(vimModeScriptPath .. "lib/utils/string_utils.lua")

local LineEnd = Motion:new{ name = 'line_end' }

function LineEnd.getRange(_, buffer, operator, repeatTimes)
  repeatTimes = repeatTimes or 1
  
  local currentLine = buffer:getCurrentLineNumber()
  local targetLine = currentLine + repeatTimes - 1
  
  -- Get the end of the target line
  local targetLineRange = buffer:getRangeForLineNumber(targetLine)
  local finish = targetLineRange:positionEnd()

  -- Get the content to check for newline
  local contents = buffer:getValue()
  local targetLineText = contents:sub(targetLineRange.location + 1, finish)
  
  if stringUtils.lastChar(targetLineText) == "\n" then
    finish = finish - 1
  end

  local range = {
    start = buffer:getCaretPosition(),
    finish = finish,
    -- the vim manual says this is an inclusive motion, but I swear
    -- it *behaves* like an exclusive motion, so I'm keeping it this way
    -- for now as it feels more correct. I might be missing some key things
    -- here though.
    mode = 'exclusive',
    direction = 'characterwise'
  }

  return range
end

function LineEnd.getMovements()
  return {
    {
      modifiers = { 'ctrl' },
      key = 'e',
      selection = true
    }
  }
end

return LineEnd
