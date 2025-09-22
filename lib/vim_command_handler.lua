local VimCommandHandler = {}

function VimCommandHandler:setPendingInput(value)
  self.commandState:setPendingInput(value)

  self:updateStateIndicator()

  return self
end

function VimCommandHandler:resetCommandState()
  self.commandState = CommandState:new()
end

function VimCommandHandler:enterOperator(operator)
  self.commandState.operator = operator
end

function VimCommandHandler:enterMotion(motion)
  self.commandState.motion = motion
end

function VimCommandHandler:pushDigitTo(type, digit)
  self.commandState:pushCountDigit(type, digit)
  self:updateStateIndicator()
  return self
end

function VimCommandHandler:fireCommandState()
  local operator = self.commandState.operator
  local motion = self.commandState.motion

  local strategies = {
    AccessibilityStrategy:new(self),
    KeyboardStrategy:new(self)
  }

  local strategy = findFirst(strategies, function(strategy)
    return strategy:isValid()
  end)

  if not strategy then
    vimLogger.e("No valid strategy found for command execution")
    return {
      mode = self.mode,
      transition = 'normal',
      hadMotion = false,
      hadOperator = false
    }
  end

  local success, result = pcall(function()
    strategy:fire()
    self.commandState:resetCharsEntered()
  end)

  if not success then
    vimLogger.e("Strategy execution failed: " .. tostring(result))
    self.commandState:resetCharsEntered()
    return {
      mode = self.mode,
      transition = 'normal',
      hadMotion = not not motion,
      hadOperator = not not operator
    }
  end

  local transition

  if operator then
    transition = operator.getModeForTransition()
  else
    transition = motion.getModeForTransition()
  end

  return {
    mode = self.mode,
    transition = transition,
    hadMotion = not not motion,
    hadOperator = not not operator
  }
end

function VimCommandHandler:collapseSelection()
  local collapsed = self.buffer:collapseSelectionToPosition(
    self.visualCaretPosition
  )

  if collapsed then
    self.stateIndicator:update()
  end
end

return VimCommandHandler