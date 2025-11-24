#!/usr/bin/env bash
#
# Git Configuration
#
# This sets up git with user credentials and preferences

set -e

source "$(dirname "$0")/../helper.sh"

info "Setting up Git configuration"

# Check if git is available
if ! command -v git >/dev/null 2>&1; then
    info "git not found - it should be installed via Homebrew first"
    exit 0
fi

success "git is available: $(git --version)"

# Check if git is already configured
if git config --global user.name >/dev/null 2>&1 && git config --global user.email >/dev/null 2>&1; then
    current_name=$(git config --global user.name)
    current_email=$(git config --global user.email)
    success "Git already configured:"
    info "  Name: $current_name"
    info "  Email: $current_email"

    # Configure credential helper for macOS
    if [ "$(uname -s)" = "Darwin" ]; then
        git config --global credential.helper osxkeychain 2>/dev/null || info "credential helper may already be set"
    fi
else
    info "Git user configuration not found"
    info "You can configure git manually with:"
    info "  git config --global user.name 'Your Name'"
    info "  git config --global user.email 'your.email@example.com'"
fi

success "Git configuration completed"
exit 0
