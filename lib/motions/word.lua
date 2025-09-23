local Motion = dofile(vimModeScriptPath .. "lib/motion.lua")
local EndOfWord = dofile(vimModeScriptPath .. "lib/motions/end_of_word.lua")
local stringUtils = dofile(vimModeScriptPath .. "lib/utils/string_utils.lua")
local utf8 = dofile(vimModeScriptPath .. "vendor/luautf8.lua")

local Word = Motion:new{ name = 'word' }

local isPunctuation = stringUtils.isPunctuation
local isWhitespace = stringUtils.isWhitespace
local isPrintableChar = stringUtils.isPrintableChar

-- word motion, exclusive
--
-- from :help motions.txt
--
-- <S-Right>	or					*<S-Right>* *w*
-- w			[count] words forward.  |exclusive| motion.
--
--
-- https://pubs.opengroup.org/onlinepubs/9699919799/utilities/vi.html
--

-- TODO handle more edge cases for :help word
function Word.getRange(_, buffer, operator, repeatTimes)
  repeatTimes = repeatTimes or 1
  
  local start = buffer:getCaretPosition()
  local currentPos = start
  
  -- Handle special case: "cw" and "cW" are treated like "ce" and "cE" if the
  -- cursor is on a non-blank. This is because "cw" is interpreted as
  -- change-word, and a word does not include the following white space.
  local contents = buffer:getValue()
  local startingChar = utf8.sub(contents, start + 1, start + 1)
  
  if not isWhitespace(startingChar) and operator and operator.name == 'change' then
    return EndOfWord:new():getRange(buffer, operator, repeatTimes)
  end
  
  -- Apply word motion repeatTimes
  for i = 1, repeatTimes do
    local singleWordRange = Word.getSingleWordRange(currentPos, buffer, operator)
    if not singleWordRange then break end
    currentPos = singleWordRange.finish
  end
  
  return {
    start = start,
    finish = currentPos,
    mode = 'exclusive',
    direction = 'characterwise'
  }
end

-- Extract single word motion logic into separate function
function Word.getSingleWordRange(startPos, buffer, operator)
  local start = startPos

  local range = {
    start = start,
    mode = 'exclusive',
    direction = 'characterwise'
  }

  range.finish = start

  local seenWhitespace = false
  local bufferLength = buffer:getLength()
  local contents = buffer:getValue()

  local startingChar = utf8.sub(
    contents,
    range.finish + 1,
    range.finish + 1
  )

  -- From :h word
  --
  -- Special case: "cw" and "cW" are treated like "ce" and "cE" if the
  -- cursor is on a non-blank. This is because "cw" is interpreted as
  -- change-word, and a word does not include the following white space.
  if not isWhitespace(startingChar) and operator and operator.name == 'change' then
    return EndOfWord:new():getRange(buffer, operator)
  end

  local startedOnPunctuation = isPunctuation(startingChar)

  while range.finish < bufferLength do
    local charIndex = range.finish + 1 -- lua strings are 1-indexed :(
    local char = utf8.sub(contents, charIndex, charIndex)

    if char == "\n" then
      if start == range.finish then range.finish = range.finish + 1 end

      break
    end

    if startedOnPunctuation then
      if isPrintableChar(char) then break end
    else
      if seenWhitespace and not isWhitespace(char) then break end
      if isPunctuation(char) then break end

      if not seenWhitespace and isWhitespace(char) then
        seenWhitespace = true
      end
    end

    range.finish = range.finish + 1
  end

  if range.finish == bufferLength then
    -- don't go off the right edge of the buffer
    range.mode = 'inclusive'
  end

  return range
end

function Word.getMovements()
  return {
    {
      modifiers = { 'alt' },
      key = 'right',
      selection = true
    }
  }
end

return Word
