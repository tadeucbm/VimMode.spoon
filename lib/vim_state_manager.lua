local VimStateManager = {}

function VimStateManager:isMode(name)
  return self.mode == name
end

function VimStateManager:setInsertMode()
  self.mode = 'insert'

  self:disableBlockCursor()
  self:exitAllModals()
  self:updateStateIndicator()
end

function VimStateManager:setNormalMode()
  self.mode = 'normal'

  self:enableBlockCursor()
  self:updateStateIndicator()
end

function VimStateManager:setVisualMode()
  self.mode = 'visual'

  self:updateStateIndicator()

  -- Need to capture this to know where visual mode initially started
  -- for some motions
  self.visualCaretPosition = self.buffer:getCaretPosition()
end

function VimStateManager:enter()
  if not self.enabled then return self end

  if self.state.current == 'normal-mode' then
    self:exit()
  else
    self.state:enterNormal()
  end

  return self
end

function VimStateManager:exit()
  self.state:enterInsert()

  return self
end

function VimStateManager:disable()
  self.enabled = false

  self:disableSequence()
  self:setInsertMode()

  return self
end

function VimStateManager:enable()
  self.enabled = true

  self:enableSequence()

  return self
end

function VimStateManager:cancel()
  self:exitAllModals()
  self:resetCommandState()
end

function VimStateManager:setVisualCaretPosition(position)
  self.visualCaretPosition = position

  -- Some motions need this called after their positioning update
  if self:isMode('visual') then
    self:updateStateIndicator()
  end
end

return VimStateManager