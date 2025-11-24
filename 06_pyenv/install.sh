#!/usr/bin/env bash
#
# Python Environment
#
# This configures Python using pyenv

set -e

source "$(dirname "$0")/../helper.sh"

info "Setting up Python environment with pyenv"

# Check if pyenv is available
if ! command -v pyenv >/dev/null 2>&1; then
    info "pyenv not found - it should be installed via Homebrew first"
    exit 0
fi

# Check current Python version
current_version=$(pyenv version-name 2>/dev/null || echo "none")
target_version="3.12"

if [[ "$current_version" =~ ^$target_version ]]; then
    success "Python $current_version already configured as global version"
else
    info "current global Python version: $current_version"
    info "installing Python $target_version (latest stable)"

    # Install latest stable Python version
    if pyenv install "$target_version" 2>/dev/null; then
        pyenv global "$target_version"
        success "Python $target_version installed and set as global"
    else
        info "Python $target_version may already be installed"
        pyenv global "$target_version" 2>/dev/null || info "Could not set global Python version"
    fi
fi

# Verify installation
if command -v python3 >/dev/null 2>&1; then
    success "Python environment ready: $(python3 --version)"
else
    info "Python3 command not available - shell restart may be required"
fi

exit 0
