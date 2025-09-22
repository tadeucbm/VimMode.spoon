local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")

local FindCharacter = Motion:new{ name = 'find_character' }

function FindCharacter.getRange(_, buffer, options, repeatTimes)
  local charToFind = options.char
  local contents = buffer:getValue()
  local start = buffer:getCaretPosition()
  local finish = start

  local currentLine = buffer:getCurrentLine()
  local currentLineRange = buffer:getCurrentLineRange()

  local found = false
  for i = start + 1, currentLineRange.location + currentLineRange.length do
    if string.sub(contents, i + 1, i + 1) == charToFind then
      finish = i
      found = true
      break
    end
  end

  if not found then
    finish = start
  end

  return {
    start = start,
    finish = finish,
    mode = 'inclusive',
    direction = 'characterwise'
  }
end

return FindCharacter