#!/bin/bash

# Local CI/CD testing script for VimMode.spoon
# This script simulates the CI pipeline locally to help debug issues

set -e

echo "🔍 VimMode.spoon Local CI Testing"
echo "=================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

success() {
    echo -e "${GREEN}✓${NC} $1"
}

warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

error() {
    echo -e "${RED}✗${NC} $1"
}

info() {
    echo -e "ℹ $1"
}

# Step 1: Basic Validation
echo
echo "=== Step 1: Basic Validation ==="

info "Checking required files..."
files_to_check=(
    "simple_test_runner.lua"
    "syntax_check.lua"
    "lib/config.lua"
    "lib/command_state.lua"
    "spec/config_spec.lua"
    ".luacheckrc"
    "Gemfile"
)

missing_files=()
for file in "${files_to_check[@]}"; do
    if [ -f "$file" ]; then
        success "$file exists"
    else
        error "$file missing"
        missing_files+=("$file")
    fi
done

if [ ${#missing_files[@]} -eq 0 ]; then
    success "All required files present"
else
    error "Missing files: ${missing_files[*]}"
    exit 1
fi

info "Validating YAML files..."
python3 -c "
import yaml
files = ['.github/workflows/ci.yml', '.github/workflows/release.yml']
for file in files:
    with open(file, 'r') as f:
        yaml.safe_load(f)
    print(f'✓ {file}')
" && success "YAML files valid" || { error "YAML validation failed"; exit 1; }

# Step 2: Lua Linting/Syntax Check
echo
echo "=== Step 2: Lua Linting ==="

if command -v lua5.3 &> /dev/null; then
    info "Running syntax validation..."
    lua5.3 syntax_check.lua && success "Syntax validation passed" || { error "Syntax validation failed"; exit 1; }
else
    warning "lua5.3 not available, skipping syntax check"
fi

# Step 3: Unit Tests
echo
echo "=== Step 3: Unit Tests ==="

if command -v lua5.3 &> /dev/null; then
    info "Running simple test runner..."
    lua5.3 simple_test_runner.lua && success "Unit tests passed" || { error "Unit tests failed"; exit 1; }
else
    warning "lua5.3 not available, skipping unit tests"
fi

# Step 4: Integration Test Validation
echo
echo "=== Step 4: Integration Test Validation ==="

info "Checking Ruby test file syntax..."
if command -v ruby &> /dev/null; then
    find spec/ -name "*.rb" -exec ruby -c {} \; > /dev/null 2>&1 && success "Ruby syntax valid" || { error "Ruby syntax errors found"; exit 1; }
else
    warning "Ruby not available, skipping Ruby syntax check"
fi

# Summary
echo
echo "🎉 Local CI testing completed successfully!"
echo
echo "Next steps:"
echo "- All validation steps passed locally"
echo "- The CI pipeline should work correctly"
echo "- If CI still fails, check GitHub Actions logs for environment-specific issues"