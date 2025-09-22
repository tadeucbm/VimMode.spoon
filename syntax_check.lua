#!/usr/bin/env lua5.3

-- Syntax validation script for VimMode.spoon
-- This script checks basic Lua syntax without executing the files

local function checkLuaSyntax(filepath)
  -- Read the file
  local file = io.open(filepath, "r")
  if not file then
    return false, "Could not open file"
  end
  
  local content = file:read("*all")
  file:close()
  
  -- Try to compile the Lua code without executing it
  local func, err = load(content, filepath)
  if not func then
    return false, err
  end
  
  return true, nil
end

local function isLuaFile(filename)
  return filename:match("%.lua$") ~= nil
end

local function scanDirectory(dir)
  local handle = io.popen('find ' .. dir .. ' -name "*.lua"')
  local files = {}
  
  for file in handle:lines() do
    table.insert(files, file)
  end
  
  handle:close()
  return files
end

-- Main validation
local totalFiles = 0
local validFiles = 0
local errors = {}

print("=== VimMode.spoon Lua Syntax Validation ===")

-- Check files that don't depend on vimModeScriptPath first
local independentFiles = {
  "lib/config.lua",
  "lib/utils/number_utils.lua",
  "lib/utils/inspect.lua",
  "lib/utils/log.lua",
  "lib/utils/prequire.lua",
  "lib/selection.lua"
}

print("\n--- Checking independent modules ---")
for _, file in ipairs(independentFiles) do
  totalFiles = totalFiles + 1
  local ok, err = checkLuaSyntax(file)
  if ok then
    validFiles = validFiles + 1
    print("✓ " .. file)
  else
    print("✗ " .. file .. " - " .. err)
    table.insert(errors, {file = file, error = err})
  end
end

-- Check our new refactored modules
local refactoredFiles = {
  "lib/vim_configuration.lua",
  "lib/vim_state_manager.lua", 
  "lib/vim_command_handler.lua",
  "lib/vim_modal_manager.lua",
  "lib/contextual_modal_optimizations.lua"
}

print("\n--- Checking refactored modules ---")
for _, file in ipairs(refactoredFiles) do
  totalFiles = totalFiles + 1
  local ok, err = checkLuaSyntax(file)
  if ok then
    validFiles = validFiles + 1
    print("✓ " .. file)
  else
    print("✗ " .. file .. " - " .. err)
    table.insert(errors, {file = file, error = err})
  end
end

-- Report results
print(string.format("\n=== Syntax Validation Results ==="))
print(string.format("Files checked: %d", totalFiles))
print(string.format("Valid syntax: %d", validFiles))
print(string.format("Syntax errors: %d", totalFiles - validFiles))

if #errors > 0 then
  print("\n--- Syntax Errors ---")
  for _, error in ipairs(errors) do
    print(string.format("%s: %s", error.file, error.error))
  end
end

if validFiles == totalFiles then
  print("\nAll checked files have valid Lua syntax! ✓")
  os.exit(0)
else
  print(string.format("\n%d files have syntax errors! ✗", totalFiles - validFiles))
  os.exit(1)
end