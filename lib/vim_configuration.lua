local VimConfiguration = {}

function VimConfiguration:enableBetaFeature(feature)
  self.config:enableBetaFeature(feature)
end

function VimConfiguration:shouldShowAlertInNormalMode(showAlert)
  self.config.shouldShowAlertInNormalMode = showAlert

  return self
end

function VimConfiguration:shouldDimScreenInNormalMode(shouldDimScreen)
  self.config.shouldDimScreenInNormalMode = shouldDimScreen

  return self
end

function VimConfiguration:disableForApp(appName)
  self.appWatcher.disabled[appName] = true

  return self
end

function VimConfiguration:setAlertFont(name)
  self.config.alert.font = name

  return self
end

function VimConfiguration:setFallbackOnlyUrlPatterns(patterns)
  self.config.fallbackOnlyUrlPatterns = patterns
end

function VimConfiguration:useFallbackMode(appName)
  if not appName then
    appName = hs.application.frontmostApplication():name()
  end

  local isBanned = (
    AccessibilityBuffer.bannedApps[appName] or
    self.appWatcher.disabled[appName] or
    self.config.fallbackOnlyApps[appName]
  )

  return isBanned
end

function VimConfiguration:shouldDimScreen()
  return self.config.shouldDimScreenInNormalMode and self:isMode('normal')
end

function VimConfiguration:canUseAdvancedMode()
  return not self:useFallbackMode()
end

function VimConfiguration:disableHotPatcher()
  self.hotPatcher:stop()

  return self
end

return VimConfiguration