local VimMode = {
  author = "David Balatero <dbalatero@gmail.com>",
  homepage = "https://github.com/dbalatero/VimMode.spoon",
  license = "ISC",
  name = "VimMode",
  version = "1.0.0",
  spoonPath = vimModeScriptPath
}

---------------------------------------------
-- Push ./vendor to the load path
package.path = vimModeScriptPath .. "vendor/?/init.lua;" .. package.path
package.cpath = vimModeScriptPath .. "vendor/?.so;" .. package.cpath

vimLogger = hs.logger.new('vim', 'debug')

local ax = dofile(vimModeScriptPath .. "lib/axuielement.lua")
dofile(vimModeScriptPath .. "lib/utils/benchmark.lua")
dofile(vimModeScriptPath .. "lib/utils/browser.lua")

local AccessibilityBuffer = dofile(vimModeScriptPath .. "lib/accessibility_buffer.lua")
local AccessibilityStrategy = dofile(vimModeScriptPath .. "lib/strategies/accessibility_strategy.lua")
local AppWatcher = dofile(vimModeScriptPath .. "lib/app_watcher.lua")
local BlockCursor = dofile(vimModeScriptPath .. "lib/block_cursor.lua")
local CommandState = dofile(vimModeScriptPath .. "lib/command_state.lua")
local Config = dofile(vimModeScriptPath .. "lib/config.lua")
local KeySequence = dofile(vimModeScriptPath .. "lib/key_sequence.lua")
local KeyboardStrategy = dofile(vimModeScriptPath .. "lib/strategies/keyboard_strategy.lua")
local ScreenDimmer = dofile(vimModeScriptPath .. "lib/screen_dimmer.lua")
local StateIndicator = dofile(vimModeScriptPath .. "lib/state_indicator.lua")

local createFocusWatcher = dofile(vimModeScriptPath .. "lib/focus_watcher.lua")
local createHotPatcher = dofile(vimModeScriptPath .. "lib/hot_patcher.lua")
local createVimModal = dofile(vimModeScriptPath .. "lib/modal.lua")
local createStateMachine = dofile(vimModeScriptPath .. "lib/state.lua")
local debug = dofile(vimModeScriptPath .. "lib/utils/debug.lua")
local findFirst = dofile(vimModeScriptPath .. "lib/utils/find_first.lua")
local keyUtils = dofile(vimModeScriptPath .. "lib/utils/keys.lua")

-- Load mixins for modular functionality
local VimConfiguration = dofile(vimModeScriptPath .. "lib/vim_configuration.lua")
local VimStateManager = dofile(vimModeScriptPath .. "lib/vim_state_manager.lua")
local VimCommandHandler = dofile(vimModeScriptPath .. "lib/vim_command_handler.lua")
local VimModalManager = dofile(vimModeScriptPath .. "lib/vim_modal_manager.lua")

VimMode.utils = {
  debug = debug,
}

local function alertDeprecation(msg)
  hs.alert.show(
    "Deprecated: " .. msg,
    {},
    hs.screen.mainScreen(),
    15
  )
end

-- Merge mixins into VimMode
for key, value in pairs(VimConfiguration) do
  VimMode[key] = value
end

for key, value in pairs(VimStateManager) do
  VimMode[key] = value
end

for key, value in pairs(VimCommandHandler) do
  VimMode[key] = value
end

for key, value in pairs(VimModalManager) do
  VimMode[key] = value
end

function VimMode:new()
  local vim = {}

  setmetatable(vim, self)
  self.__index = self

  vim:resetCommandState()

  vim.blockCursor = BlockCursor:new(vim)
  vim.config = Config:new()
  vim.enabled = true
  vim.mode = 'insert'

  vim.modal = createVimModal(vim):setOnBeforePress(function(mods, key)
    local realKey = keyUtils.getRealChar(mods, key)
    vim.commandState:pushChar(realKey)
    vim:updateStateIndicator()
  end)

  vim.state = createStateMachine(vim)
  vim.sequence = nil

  vim.buffer = nil
  vim.visualCaretPosition = nil

  vim.hotPatcher = createHotPatcher()
  vim.hotPatcher:start()

  vim.appWatcher = AppWatcher:new(vim):start()
  vim.focusWatcher = createFocusWatcher(vim)
  vim.stateIndicator = StateIndicator:new(vim):update()

  vim.enterKeyBind = nil

  return vim
end

-- Spoon API conformity

-- Allows binding entering normal mode to a hot key
--
-- vim:bindHotKeys({ enter = { {'cmd', 'shift'}, 'v' } })
function VimMode:bindHotKeys(keyTable)
  if keyTable.enter then
    local enter = keyTable.enter

    self.enterKeyBind = hs.hotkey.bind(enter[1], enter[2], function()
      self:enter()
    end)
  end

  return self
end

return VimMode