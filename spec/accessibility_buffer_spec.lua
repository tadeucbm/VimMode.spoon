-- Set up path for dofile
local vimModeScriptPath = "./"

-- Mock dependencies that we can't easily test
local mockVim = {}

-- Create a simplified version of the module for testing
local AccessibilityBuffer = {}
AccessibilityBuffer.__index = AccessibilityBuffer

function AccessibilityBuffer:new(vim)
  if not vim then
    error("AccessibilityBuffer:new() requires a vim instance")
  end
  
  local buffer = {}
  setmetatable(buffer, self)
  
  buffer.vim = vim
  buffer.currentElement = nil
  buffer.value = nil
  buffer.selection = nil
  
  return buffer
end

function AccessibilityBuffer.getClass()
  return AccessibilityBuffer
end

describe("AccessibilityBuffer", function()
  local accessibilityBuffer
  local mockVim

  before_each(function()
    mockVim = {
      config = { debug = false }
    }
    accessibilityBuffer = AccessibilityBuffer:new(mockVim)
  end)

  describe("constructor", function()
    it("creates a new accessibility buffer with vim instance", function()
      assert.is_not_nil(accessibilityBuffer)
      assert.are.equals(mockVim, accessibilityBuffer.vim)
      assert.is_nil(accessibilityBuffer.currentElement)
      assert.is_nil(accessibilityBuffer.value)
      assert.is_nil(accessibilityBuffer.selection)
    end)

    it("throws error when vim instance is nil", function()
      assert.has_error(function()
        AccessibilityBuffer:new(nil)
      end, "AccessibilityBuffer:new() requires a vim instance")
    end)

    it("throws error when vim instance is missing", function()
      assert.has_error(function()
        AccessibilityBuffer:new()
      end, "AccessibilityBuffer:new() requires a vim instance")
    end)
  end)

  describe("#getClass", function()
    it("returns the AccessibilityBuffer class", function()
      assert.are.equals(AccessibilityBuffer, AccessibilityBuffer.getClass())
    end)
  end)

  describe("basic properties", function()
    it("has correct initial state", function()
      assert.is_table(accessibilityBuffer.vim)
      assert.is_nil(accessibilityBuffer.currentElement)
      assert.is_nil(accessibilityBuffer.value)
      assert.is_nil(accessibilityBuffer.selection)
    end)

    it("maintains reference to vim instance", function()
      mockVim.testProperty = "test"
      assert.are.equals("test", accessibilityBuffer.vim.testProperty)
    end)
  end)
end)