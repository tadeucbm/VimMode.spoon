local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")
local stringUtils = dofile(vimModeScriptPath .. "lib/utils/string_utils.lua")
local utf8 = dofile(vimModeScriptPath .. "vendor/luautf8.lua")

local FirstNonBlank = Motion:new{ name = 'first_non_blank' }

function FirstNonBlank.getRange(_, buffer, operator, repeatTimes)
  repeatTimes = repeatTimes or 1
  
  local success, result = pcall(function()
    local start = buffer:getCaretPosition()
    local bufferLength = buffer:getLength()
    local contents = buffer:getValue()

    if not contents then
      return {
        start = start,
        finish = start,
        mode = 'exclusive',
        direction = 'characterwise'
      }
    end

    local range = {
      start = start,
      mode = 'exclusive',
      direction = 'characterwise'
    }

    range.finish = start

    while range.finish < bufferLength do
      local charIndex = range.finish + 1 -- lua strings are 1-indexed :(
      local char = utf8.sub(contents, charIndex, charIndex)

      if char == "\n" then break end
      if not stringUtils.isWhitespace(char) then break end

      range.finish = range.finish + 1
    end

    return range
  end)

  if not success then
    local start = buffer:getCaretPosition()
    return {
      start = start,
      finish = start,
      mode = 'exclusive',
      direction = 'characterwise'
    }
  end

  return result
end

function FirstNonBlank.getMovements()
  return nil
end

return FirstNonBlank
