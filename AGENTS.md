# VimMode.spoon Agent Guidelines

## Build/Test Commands
- **Unit tests**: `busted spec` (run from project root after `bin/dev-setup`)
- **Single test file**: `busted spec/path/to/test_spec.lua`
- **Integration tests**: `bundle exec rspec spec` (requires setup per Integration_Tests.md)
- **All tests**: `rake spec` (runs both advanced and fallback integration tests)
- **Lint**: `luacheck lib/` (using .luacheckrc config)

## Code Style & Conventions
- **Language**: Lua for Hammerspoon environment
- **File structure**: `lib/` for source, `spec/` for tests, organized by feature
- **Imports**: Use `dofile(vimModeScriptPath .. "path/to/file.lua")` for local requires
- **Naming**: camelCase for functions/variables, PascalCase for modules/classes
- **Global state**: Prefer local variables, use `vimLogger` for logging
- **Error handling**: Use pcall() for error-prone operations, log with vimLogger
- **Tests**: Use busted framework with describe/it blocks, assert.are.equals for assertions
- **Dependencies**: Vendor external deps in `vendor/`, include via package.path manipulation
- **Documentation**: Follow existing inline comment style, focus on why not what
- **State management**: Use proper object-oriented patterns with :new() constructors
- **UTF-8**: Use vendored luautf8 library for string operations requiring Unicode support