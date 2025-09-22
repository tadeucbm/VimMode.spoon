local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")
local stringUtils = dofile(vimModeScriptPath .. "lib/utils/string_utils.lua")
local utf8 = dofile(vimModeScriptPath .. "vendor/luautf8.lua")

local BackWord = Motion:new{ name = 'back_word' }

local isPunctuation = stringUtils.isPunctuation
local isWhitespace = stringUtils.isWhitespace

function BackWord.getRange(_, buffer, _, repeatTimes)
  repeatTimes = repeatTimes or 1

  local start = buffer:getCaretPosition()
  local currentPos = start

  for _ = 1, repeatTimes do
    currentPos = BackWord.getSingleWordRange(currentPos, buffer)
  end

  return {
    start = start,
    finish = currentPos,
    mode = 'exclusive',
    direction = 'characterwise'
  }
end

function BackWord.getSingleWordRange(startPos, buffer)
  local finish = startPos
  local contents = buffer:getValue()


  -- Move back to the first non-whitespace character
  if finish > 0 then
    finish = finish - 1
  end
  while finish > 0 and isWhitespace(utf8.sub(contents, finish + 1, finish + 1)) do
    finish = finish - 1
  end

  local char = utf8.sub(contents, finish + 1, finish + 1)
  local startedOnPunctuation = isPunctuation(char)

  -- Move back to the beginning of the word
  while finish > 0 do
    char = utf8.sub(contents, finish + 1, finish + 1)
    if isWhitespace(char) then break end
    if startedOnPunctuation and not isPunctuation(char) then break end
    if not startedOnPunctuation and isPunctuation(char) then break end
    finish = finish - 1
  end

  -- If we are not at the start of the buffer, we need to move one character forward
  if finish > 0 then
    finish = finish + 1
  end

  return finish
end

return BackWord
