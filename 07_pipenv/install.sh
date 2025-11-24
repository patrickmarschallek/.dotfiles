#!/usr/bin/env bash
#
# Pipenv Configuration
#
# This configures pipenv for Python virtual environments

set -e

source "$(dirname "$0")/../helper.sh"

info "Setting up pipenv configuration"

# Check if pipenv is available
if ! command -v pipenv >/dev/null 2>&1; then
    info "pipenv not found - it should be installed via Homebrew first"
    exit 0
fi

# Check if pip is available
if ! command -v pip3 >/dev/null 2>&1; then
    info "pip3 not found - Python environment may not be set up correctly"
    exit 0
fi

# Update pip and install essential packages
info "updating pip and installing essential packages"
pip3 install -U pip setuptools wheel 2>/dev/null || info "pip update may have failed"

# Create pip config directory if it doesn't exist
pip_config_dir="$HOME/.pip"
if [ ! -d "$pip_config_dir" ]; then
    mkdir -p "$pip_config_dir"
    info "created pip configuration directory"
fi

# Configure pipenv settings for better performance
export PIPENV_VENV_IN_PROJECT=1  # Create .venv in project directory
info "pipenv configured to create virtual environments in project directories"

success "pipenv configuration completed"
info "Use 'pipenv install' in your Python projects to create virtual environments"

exit 0
