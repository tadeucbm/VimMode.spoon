local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")
local stringUtils = dofile(vimModeScriptPath .. "lib/utils/string_utils.lua")
local utf8 = dofile(vimModeScriptPath .. "vendor/luautf8.lua")

local EndOfWord = Motion:new{ name = 'end_of_word' }

local isWhitespace = stringUtils.isWhitespace

function EndOfWord.getRange(_, buffer, _, repeatTimes)
  repeatTimes = repeatTimes or 1

  local start = buffer:getCaretPosition()
  local currentPos = start

  for _ = 1, repeatTimes do
    currentPos = EndOfWord.getSingleWordRange(currentPos, buffer)
  end

  return {
    start = start,
    finish = currentPos,
    mode = 'inclusive',
    direction = 'characterwise'
  }
end

function EndOfWord.getSingleWordRange(startPos, buffer)
  local finish = startPos
  local contents = buffer:getValue()
  local length = buffer:getLength()

  -- If we are at the end of the buffer, do nothing
  if finish >= length - 1 then
    return length - 1
  end

  local char = utf8.sub(contents, finish + 1, finish + 1)

  -- If we are on a non-whitespace character, and the next character is a whitespace,
  -- then we are at the end of a word. In this case, we should skip the whitespace
  -- and find the end of the next word.
  if not isWhitespace(char) and isWhitespace(utf8.sub(contents, finish + 2, finish + 2)) then
    -- Skip whitespace
    while finish < length - 1 and isWhitespace(utf8.sub(contents, finish + 2, finish + 2)) do
      finish = finish + 1
    end
  end

  -- Move to the end of the next word
  while finish < length - 1 and not isWhitespace(utf8.sub(contents, finish + 2, finish + 2)) do
    finish = finish + 1
  end

  return finish
end

return EndOfWord
