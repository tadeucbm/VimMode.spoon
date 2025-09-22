local VimModalManager = {}

function VimModalManager:enterWithSequence(keys, maxDelayBetweenKeysMilliseconds)
  maxDelayBetweenKeysMilliseconds = maxDelayBetweenKeysMilliseconds or 30

  self.sequence = KeySequence:new(keys, function()
    self:enter()
  end, maxDelayBetweenKeysMilliseconds)

  return self
end

function VimModalManager:enableKeySequence(key1, key2)
  local depMessage = "vim:enableKeySequence is deprecated. Use vim:enterWithSequence instead"
  alertDeprecation(depMessage)

  return self:enterWithSequence(key1 .. key2)
end

function VimModalManager:disableEnterBind()
  if self.enterKeyBind then
    self.enterKeyBind:delete()
    self.enterKeyBind = nil
  end

  return self
end

function VimModalManager:enableEnterBind()
  -- only enable if was disabled somehow
  return self
end

function VimModalManager:disableSequence()
  if self.sequence then
    self.sequence:delete()
    self.sequence = nil
  end

  return self
end

function VimModalManager:enableSequence()
  return self
end

function VimModalManager:exitAsync()
  return hs.timer.doAfter(0.01, function()
    self:exit()
  end)
end

function VimModalManager:exitModalAsync()
  local currentContext = self.modal.currentContext

  self:exitAllModals()

  return currentContext
end

function VimModalManager:exitAllModals()
  self.modal:exitAll()
end

function VimModalManager:enterModal(name)
  self.modal:enterContext(name)

  return self
end

function VimModalManager:updateStateIndicator()
  self.stateIndicator:update()
end

function VimModalManager:enableBlockCursor()
  if self.blockCursor then
    self.blockCursor:show()
  end
end

function VimModalManager:disableBlockCursor()
  if self.blockCursor then
    self.blockCursor:hide()
  end
end

return VimModalManager