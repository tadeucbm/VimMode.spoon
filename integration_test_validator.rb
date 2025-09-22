#!/usr/bin/env ruby
# frozen_string_literal: true

# Integration Test Setup Validator for VimMode.spoon
# This script helps validate that the environment is ready for integration testing

puts "=== VimMode.spoon Integration Test Environment Validator ==="
puts

# Check if we're on macOS
unless RUBY_PLATFORM.include?('darwin')
  puts "❌ Integration tests require macOS"
  puts "   Current platform: #{RUBY_PLATFORM}"
  exit 1
end

puts "✅ Running on macOS"

# Check if Hammerspoon is installed
hammerspoon_app = "/Applications/Hammerspoon.app"
if File.exist?(hammerspoon_app)
  puts "✅ Hammerspoon is installed"
else
  puts "❌ Hammerspoon not found at #{hammerspoon_app}"
  puts "   Install with: brew install --cask hammerspoon"
  exit 1
end

# Check if Chrome/Chromium is available
chrome_paths = [
  "/Applications/Google Chrome.app",
  "/Applications/Chromium.app"
]

chrome_found = chrome_paths.any? { |path| File.exist?(path) }
if chrome_found
  puts "✅ Chrome/Chromium is available"
else
  puts "❌ Chrome or Chromium not found"
  puts "   Install Chrome from: https://www.google.com/chrome/"
  exit 1
end

# Check if chromedriver is installed
begin
  `chromedriver --version`
  if $?.success?
    puts "✅ ChromeDriver is installed"
  else
    puts "❌ ChromeDriver is not working properly"
    exit 1
  end
rescue
  puts "❌ ChromeDriver not found in PATH"
  puts "   Install with: brew install chromedriver"
  exit 1
end

# Check Ruby dependencies
puts
puts "Checking Ruby dependencies..."

required_gems = %w[rspec capybara selenium-webdriver webdrivers]
missing_gems = []

required_gems.each do |gem_name|
  begin
    require gem_name
    puts "✅ #{gem_name} gem available"
  rescue LoadError
    puts "❌ #{gem_name} gem not found"
    missing_gems << gem_name
  end
end

unless missing_gems.empty?
  puts
  puts "Missing gems. Install with:"
  puts "  bundle install"
  exit 1
end

# Check if VimMode.spoon is properly set up
vimmode_path = File.expand_path("~/.hammerspoon/Spoons/VimMode.spoon")
if File.exist?(vimmode_path)
  puts "✅ VimMode.spoon found in Hammerspoon Spoons directory"
else
  puts "⚠️  VimMode.spoon not found at #{vimmode_path}"
  puts "   You may need to install it for testing"
end

puts
puts "=== Environment Check Summary ==="
puts "✅ macOS detected"
puts "✅ Hammerspoon installed"  
puts "✅ Chrome/Chromium available"
puts "✅ ChromeDriver installed"
puts "✅ Ruby dependencies available"

puts
puts "🎉 Environment is ready for integration testing!"
puts
puts "Next steps:"
puts "1. Make sure Hammerspoon is running"
puts "2. Load VimMode.spoon in Hammerspoon (if testing local changes)"
puts "3. Grant accessibility permissions when prompted"
puts "4. Run tests with: bundle exec rspec spec/"
puts
puts "For more details, see: docs/Integration_Tests.md"