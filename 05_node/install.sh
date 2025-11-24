#!/usr/bin/env bash
#
# Node.js Environment
#
# This configures Node.js using nvm

set -e

source "$(dirname "$0")/../helper.sh"

info "Setting up Node.js environment with nvm"

# Check if nvm is available
if ! command -v nvm >/dev/null 2>&1; then
    info "nvm not found - it should be installed via Homebrew first"
    exit 0
fi

# Load nvm if not already loaded
if ! command -v nvm >/dev/null 2>&1; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
fi

# Install latest LTS Node.js if not present
if ! command -v node >/dev/null 2>&1; then
    info "installing latest LTS Node.js"
    nvm install --lts
    nvm use --lts
    success "Node.js LTS installed"
else
    success "Node.js already available: $(node --version)"
fi

# Verify npm is available
if ! command -v npm >/dev/null 2>&1; then
    info "npm not found - Node.js installation may be incomplete"
    exit 0
else
    success "npm is available: $(npm --version)"
fi

# Install yarn if not present and not already in Brewfile
if ! command -v yarn >/dev/null 2>&1; then
    info "installing yarn globally"
    npm install -g yarn 2>/dev/null || info "yarn installation may have failed"
    if command -v yarn >/dev/null 2>&1; then
        success "yarn installed: $(yarn --version)"
    fi
else
    success "yarn already available: $(yarn --version)"
fi

success "Node.js environment ready"
exit 0
