-- luacheck configuration for VimMode.spoon
std = "none"
codes = true

globals = {
  -- Hammerspoon globals
  "hs",
  "spoon",
  
  -- VimMode.spoon specific globals
  "vimModeScriptPath",
  "vimLogger",
}

read_globals = {
  -- Lua builtins
  "_G",
  "assert",
  "error",
  "getmetatable",
  "ipairs",
  "next",
  "pairs",
  "pcall",
  "print",
  "rawget",
  "rawset",
  "require",
  "select",
  "setmetatable",
  "tonumber",
  "tostring",
  "type",
  "unpack",
  "xpcall",
  
  -- String operations
  "string",
  
  -- Table operations
  "table",
  
  -- Math operations
  "math",
  
  -- OS operations
  "os",
  
  -- IO operations
  "io",
  
  -- Debug operations
  "debug",
  
  -- UTF-8 operations (vendored)
  "utf8",
}

exclude_files = {
  "vendor/",
  "spec/fixtures/",
}

-- Ignore certain warnings in test files
files["spec/**/*.lua"] = {
  globals = {
    "describe",
    "it",
    "before",
    "after",
    "setup",
    "teardown",
    "pending",
    "finally",
    "spy",
    "stub",
    "mock",
    "assert",
  }
}

-- Specific rules for different file types
files["lib/**/*.lua"] = {
  max_line_length = 120,
}

-- Ignore warnings for external dependencies
files["vendor/**/*.lua"] = {
  ignore = {".*"}
}