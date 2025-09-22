#!/usr/bin/env lua5.3

-- Simple test runner for VimMode.spoon that doesn't require external dependencies

-- Set up the environment
vimModeScriptPath = ""
package.path = "lib/?.lua;lib/?/init.lua;spec/?.lua;" .. package.path

-- Simple assertion library
local _assert = assert  -- Save the original assert
assert = {}
assert.are = {}

function assert.are.equals(expected, actual)
  if expected ~= actual then
    error(string.format("Expected %s, but got %s", tostring(expected), tostring(actual)))
  end
end

function assert.is_not_nil(value)
  if value == nil then
    error("Expected value to not be nil")
  end
end

function assert.is_table(value)
  if type(value) ~= "table" then
    error(string.format("Expected table, but got %s", type(value)))
  end
end

function assert.is_true(value)
  if value ~= true then
    error(string.format("Expected true, but got %s", tostring(value)))
  end
end

function assert.is_false(value)
  if value ~= false then
    error(string.format("Expected false, but got %s", tostring(value)))
  end
end

function assert.has_error(func, expected_message)
  local ok, err = pcall(func)
  if ok then
    error("Expected function to throw an error, but it didn't")
  end
  if expected_message and not string.find(err, expected_message, 1, true) then
    error(string.format("Expected error message to contain '%s', but got '%s'", expected_message, err))
  end
end

-- Simple test framework
local tests_run = 0
local tests_passed = 0

function describe(name, func)
  print("Running: " .. name)
  func()
end

function it(name, func)
  tests_run = tests_run + 1
  local ok, err = pcall(func)
  if ok then
    tests_passed = tests_passed + 1
    print("  ✓ " .. name)
  else
    print("  ✗ " .. name .. " - " .. err)
  end
end

function before_each(func)
  -- Simple implementation
end

-- Test Config module
print("=== Testing Config Module ===")
local Config = require('lib/config')

describe("Config", function()
  it("creates with default values", function()
    local config = Config:new()
    assert.is_not_nil(config)
    assert.are.equals(true, config.shouldShowAlertInNormalMode)
    assert.are.equals("Courier New", config.alert.font)
  end)

  it("accepts constructor options", function()
    local config = Config:new({shouldShowAlertInNormalMode = false})
    assert.are.equals(false, config.shouldShowAlertInNormalMode)
  end)

  it("enables beta features", function()
    local config = Config:new()
    config:enableBetaFeature("test")
    assert.are.equals(true, config:isBetaFeatureEnabled("test"))
  end)
end)

-- Test CommandState module
print("\n=== Testing CommandState Module ===")
local CommandState = require('lib/command_state')

describe("CommandState", function()
  it("creates with empty state", function()
    local cs = CommandState:new()
    assert.is_not_nil(cs)
    assert.are.equals("", cs:getCharsEntered())
  end)

  it("pushes characters", function()
    local cs = CommandState:new()
    cs:pushChar("h")
    assert.are.equals("h", cs:getCharsEntered())
  end)

  it("calculates repeat times", function()
    local cs = CommandState:new()
    assert.are.equals(1, cs:getRepeatTimes())
  end)
end)

-- Print summary
print(string.format("\n=== Test Summary ==="))
print(string.format("Tests run: %d", tests_run))
print(string.format("Tests passed: %d", tests_passed))
print(string.format("Tests failed: %d", tests_run - tests_passed))

if tests_passed == tests_run then
  print("All tests passed! ✓")
  os.exit(0)
else
  print("Some tests failed! ✗")
  os.exit(1)
end