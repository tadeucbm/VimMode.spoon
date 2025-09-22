local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")
local stringUtils = dofile(vimModeScriptPath .. "lib/utils/string_utils.lua")
local utf8 = dofile(vimModeScriptPath .. "vendor/luautf8.lua")

local EndOfPreviousWord = Motion:new{ name = 'end_of_previous_word' }

local isWhitespace = stringUtils.isWhitespace

function EndOfPreviousWord.getRange(_, buffer, _, repeatTimes)
  repeatTimes = repeatTimes or 1

  local start = buffer:getCaretPosition()
  local currentPos = start

  for _ = 1, repeatTimes do
    currentPos = EndOfPreviousWord.getSingleWordRange(currentPos, buffer)
  end

  return {
    start = start,
    finish = currentPos,
    mode = 'inclusive',
    direction = 'characterwise'
  }
end

function EndOfPreviousWord.getSingleWordRange(startPos, buffer)
  local finish = startPos
  local contents = buffer:getValue()

  -- If we are at the beginning of the buffer, do nothing
  if finish == 0 then
    return 0
  end

  -- Move back one character
  finish = finish - 1

  -- Skip all whitespace characters
  while finish > 0 and isWhitespace(utf8.sub(contents, finish + 1, finish + 1)) do
    finish = finish - 1
  end

  -- Move to the beginning of the word
  while finish > 0 and not isWhitespace(utf8.sub(contents, finish, finish)) do
    finish = finish - 1
  end

  -- Move to the end of the word
  while finish < buffer:getLength() - 1 and not isWhitespace(utf8.sub(contents, finish + 2, finish + 2)) do
    finish = finish + 1
  end

  return finish
end

return EndOfPreviousWord