# VimMode.spoon Codebase Analysis Plan

## Analysis Approach

### 1. Initial Exploration
- Read README.md to understand project purpose, installation, and usage
- Examine project structure and file organization
- Identify build system and configuration files

### 2. Build System Investigation
- Analyzed `.busted` for unit test configuration (busted framework)
- Examined `Rakefile` for integration test setup
- Checked `.luacheckrc` for linting configuration
- Reviewed test helper files to understand test patterns

### 3. Code Convention Discovery
- Examined main entry point (`lib/vim.lua`) for import patterns
- Analyzed sample files to understand:
  - Import style: `dofile(vimModeScriptPath .. "path/to/file.lua")`
  - Naming conventions: camelCase functions, PascalCase modules
  - Module structure: object-oriented with `:new()` constructors
- Reviewed test files for testing patterns (busted framework with describe/it)

### 4. Special Features Identified
- Hammerspoon-specific Lua environment
- Custom logging via `vimLogger`
- Vendored dependencies in `vendor/` directory
- UTF-8 support via vendored luautf8 library
- Accessibility API integration for advanced mode

### 5. Missing Elements
- No Cursor rules found (.cursor/ or .cursorrules)
- No Copilot instructions found (.github/copilot-instructions.md)
- Clean project structure without additional IDE configurations

## AGENTS.md Creation Strategy

Created a concise 20-line guide covering:
- **Build Commands**: Unit tests (busted), integration tests (rspec), linting (luacheck)
- **Code Style**: Lua conventions, import patterns, naming, error handling
- **Project Structure**: lib/ for source, spec/ for tests, vendor/ for dependencies
- **Testing**: Busted framework patterns with describe/it blocks
- **Special Considerations**: Hammerspoon environment, UTF-8 handling, logging patterns

The guide provides essential information for AI agents to work effectively within this Lua/Hammerspoon codebase while maintaining existing conventions and patterns.