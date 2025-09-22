# 2021-02-13

* Added a function for running an accessibility test suite against any field: `hs.hotkey.bind(mods, key, VimMode.utils.debug.testAccessibilityField)`
  * Will add more tests to this suite as we need to debug more problems down the line-ideally people can just run this function when reporting a bug.

# Implementation Project 2024 - Comprehensive Modernization

## [Unreleased] - Major Architecture & Quality Improvements

### Added
- Comprehensive luacheck configuration (.luacheckrc) for code quality enforcement
- GitHub Actions CI/CD pipeline replacing deprecated Travis CI
- Automated release workflow with package generation and checksums
- Pre-commit hooks configuration for code quality enforcement
- Unit tests for core modules (command_state, config, accessibility_buffer)
- Unit tests for operators (change, yank)
- Performance optimizations for modal key binding lookups (O(n) → O(1))
- Modular architecture with separated concerns (vim_configuration, vim_state_manager, etc.)
- Input validation for critical constructors
- Comprehensive error handling with pcall protection and logging
- Documentation generation workflow
- Build artifact exclusion with .gitignore

### Fixed
- Duplicate function signature in word.lua (lines 57-58)
- Replace operator fallback mode support implementation
- Enhanced error handling in fireCommandState with proper logging and fallback

### Changed
- **Major Refactoring**: vim.lua (421 lines) split into focused mixins:
  - vim_configuration.lua: Configuration methods
  - vim_state_manager.lua: State management 
  - vim_command_handler.lua: Command processing
  - vim_modal_manager.lua: Modal/sequence handling
- Optimized contextual modal key binding checks from O(n) linear search to O(1) hash lookups
- Enhanced config_spec.lua with comprehensive beta feature testing
- Improved error messages and validation across core modules

### Technical Improvements
- **Test Coverage**: Increased from ~29% (21/73 files) to ~34% (26/73 files) 
- **Performance**: Significantly faster modal switching and key binding resolution
- **Architecture**: Clear separation of concerns for better maintainability
- **DevOps**: Full automation for builds, tests, releases, and documentation
- **Code Quality**: Standardized linting, formatting, and validation

### Infrastructure
- GitHub Actions CI pipeline with Lua linting, unit tests, and integration tests
- Automated release packaging with version management and changelog generation  
- Pre-commit hooks for enforcing code quality before commits
- Documentation generation and deployment to GitHub Pages

# 2020-12-28

* Added a beta feature for enforcing fallback mode on certain URL patterns in Chrome and Safari (see README)
* Made hitting `escape` when tapping `g` cancel and reset to normal mode [closes #56]

# 2020-11-30

* Rollback the keypress disallowing - it conflicts with the keys we send in fallback mode.

# 2020-11-29

* Added the `iw` "in word" text object motion
* Added the `i[`, `i<`, `i{`, `i'`, `i"`, and `i`` motions.
* Added `ctrl-u` and `ctrl-d` to page up/down half a visible screen
* Update the modal to disallow pressing keys that aren't registered with the current active mode

# 2020-11-04

* Fix offset calculations with UTF-8 characters like smart quotes.
* Add a beta feature for enabling a block cursor overlay in fields that support it in #65. Turn this on with `vim:enableBetaFeature('block_cursor_overlay')`

# 2020-10-15

* Fix the library to work on the new Lua 5.4 version of Hammerspoon. Previous releases before Hammerspoon 0.9.79 will not work anymore.

# 2020-09-06

* Fix #54 where the overlay doesn't sit above the Safari location bar

# 2020-08-30

* Allow advanced mode to work in `AXComboBox` fields

# 2020-08-29

* Passthru the main Vim normal mode keys when focused in a disabled app
* Update the key sequence to have a default timeout of 140ms to accommodate `jj` users
* Make key sequence timeout optionally configurable

There is no changelog prior to this date :(
