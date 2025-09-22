# Setting up to run integration tests

**Important**: Integration tests are designed for local development and cannot run in CI/CD environments due to accessibility permission requirements.

The integration tests require a few things up front to run:

## Prerequisites

First, ensure you have the required dependencies:

```bash
brew install chromedriver
```

## Environment Validation

Use the provided validator script to check if your environment is ready:

```bash
./integration_test_validator.rb
```

This will check for:
- macOS (required)
- Hammerspoon installation
- Chrome/Chromium browser
- ChromeDriver
- Ruby dependencies
- VimMode.spoon installation

## Permission Setup

Next, you'll have to deal with some first-run setup to give `osascript` the required permissions. This is the only way to enable RSpec to send native OS X keys. If there is a way to do this without needing permissions, please open a PR/issue!

```bash
bundle install
bundle exec rspec spec
```

It will ask for permissions for `System Events.app`, you'll need to grant them:

![image](https://user-images.githubusercontent.com/59429/70395829-c00cdf00-19b7-11ea-91c2-50cefe25b329.png)

Run `bundle exec rspec spec` again.

It will also ask for permissions for `osascript` (via iTerm), you'll need to enable iTerm under accessibility here:

![image](https://user-images.githubusercontent.com/59429/70395855-0a8e5b80-19b8-11ea-9343-5da0496cdf9b.png)

## Running Tests

You should now be able to run:

```bash
bundle exec rspec spec
```

**Note**: You can't have another instance of Chrome running while you run the tests, or else the wrong Vim modes get entered. The rspec runner will kill Chrome for you. You can get your tabs back when you open Chrome back up.

## CI/CD Notes

Integration tests **do not run in CI/CD pipelines** because they require:
- Interactive permission grants
- Accessibility API access
- Hammerspoon running with proper configuration

CI only validates:
- Ruby syntax for test files
- Test dependency availability
- Environment setup scripts
