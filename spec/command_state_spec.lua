-- Set up path for dofile
local vimModeScriptPath = "./"

-- Mock the numberUtils dependency
local numberUtils = require("lib/utils/number_utils")

-- Load the module under test
local CommandState = dofile("lib/command_state.lua")

describe("CommandState", function()
  local commandState

  before_each(function()
    commandState = CommandState:new()
  end)

  describe("constructor", function()
    it("creates a new command state with default values", function()
      assert.is_not_nil(commandState)
      assert.are.equals("", commandState:getCharsEntered())
      assert.is_nil(commandState.motion)
      assert.is_nil(commandState.motionTimes)
      assert.is_nil(commandState.operator)
      assert.is_nil(commandState.operatorTimes)
      assert.is_nil(commandState:getPendingInput())
    end)
  end)

  describe("#pushChar", function()
    it("adds a character to the entered chars", function()
      commandState:pushChar("h")
      assert.are.equals("h", commandState:getCharsEntered())
    end)

    it("concatenates multiple characters", function()
      commandState:pushChar("h")
      commandState:pushChar("j")
      commandState:pushChar("k")
      assert.are.equals("hjk", commandState:getCharsEntered())
    end)

    it("handles nil character gracefully", function()
      commandState:pushChar("h")
      commandState:pushChar(nil)
      commandState:pushChar("j")
      assert.are.equals("hj", commandState:getCharsEntered())
    end)
  end)

  describe("#resetCharsEntered", function()
    it("clears the entered characters", function()
      commandState:pushChar("test")
      commandState:resetCharsEntered()
      assert.are.equals("", commandState:getCharsEntered())
    end)

    it("returns self for chaining", function()
      local result = commandState:resetCharsEntered()
      assert.are.equals(commandState, result)
    end)
  end)

  describe("#pushCountDigit", function()
    it("adds a digit to operator count", function()
      commandState:pushCountDigit("operator", 5)
      assert.are.equals(5, commandState:getCount("operator"))
    end)

    it("adds a digit to motion count", function()
      commandState:pushCountDigit("motion", 3)
      assert.are.equals(3, commandState:getCount("motion"))
    end)

    it("accumulates multi-digit numbers", function()
      commandState:pushCountDigit("operator", 1)
      commandState:pushCountDigit("operator", 2)
      commandState:pushCountDigit("operator", 3)
      assert.are.equals(123, commandState:getCount("operator"))
    end)
  end)

  describe("#getRepeatTimes", function()
    it("returns 1 when no counts are set", function()
      assert.are.equals(1, commandState:getRepeatTimes())
    end)

    it("returns operator count when only operator is set", function()
      commandState:pushCountDigit("operator", 5)
      assert.are.equals(5, commandState:getRepeatTimes())
    end)

    it("returns motion count when only motion is set", function()
      commandState:pushCountDigit("motion", 3)
      assert.are.equals(3, commandState:getRepeatTimes())
    end)

    it("multiplies operator and motion counts", function()
      commandState:pushCountDigit("operator", 3)
      commandState:pushCountDigit("motion", 4)
      assert.are.equals(12, commandState:getRepeatTimes())
    end)
  end)

  describe("#setPendingInput and #getPendingInput", function()
    it("stores and retrieves pending input", function()
      commandState:setPendingInput("test")
      assert.are.equals("test", commandState:getPendingInput())
    end)

    it("returns self for chaining", function()
      local result = commandState:setPendingInput("test")
      assert.are.equals(commandState, result)
    end)

    it("handles nil input", function()
      commandState:setPendingInput(nil)
      assert.is_nil(commandState:getPendingInput())
    end)
  end)
end)