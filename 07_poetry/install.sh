#!/usr/bin/env bash
#
# Poetry Configuration
#
# This configures poetry for Python dependency management

set -e

source "$(dirname "$0")/../helper.sh"

info "Setting up Poetry configuration"

# Check if poetry is available
if ! command -v poetry >/dev/null 2>&1; then
    info "poetry not found - it should be installed via Homebrew first"
    exit 0
fi

# Verify poetry installation
if poetry --version >/dev/null 2>&1; then
    success "poetry is available: $(poetry --version)"
else
    info "poetry installation may need verification"
    exit 0
fi

# Configure poetry settings for better development experience
info "configuring poetry settings"

# Create virtual environments in project directory
poetry config virtualenvs.in-project true 2>/dev/null || info "could not set virtualenvs.in-project"

# Use the system's pip for faster package installation
poetry config virtualenvs.options.system-site-packages false 2>/dev/null || info "could not configure system-site-packages"

# Configure cache directory
poetry config cache-dir "$HOME/.cache/pypoetry" 2>/dev/null || info "could not set cache directory"

success "Poetry configuration completed"
info "Virtual environments will be created in project .venv directories"
info "Use 'poetry install' in your Python projects to manage dependencies"

exit 0
