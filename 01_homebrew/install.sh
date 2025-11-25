#!/usr/bin/env bash
#
# Homebrew
#
# This installs some of the common dependencies needed (or at least desired)
# using Homebrew.

set -e

source "$(dirname "$0")/../helper.sh"

# Check for Homebrew
if test ! $(which brew)
then
  info "Installing Homebrew for you."

  # Install the correct homebrew for each OS type
  if test "$(uname)" = "Darwin"
  then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    success "Homebrew installed"
  fi
else
  success "Homebrew is already installed"
fi

# Check what's already installed
SCRIPT_DIR="$(dirname "$0")"
if [ -f "$SCRIPT_DIR/check-apps.sh" ]; then
  info "Checking current installation status..."
  "$SCRIPT_DIR/check-apps.sh"
fi

# Check if Rosetta 2 is needed for Intel-based Java casks
if [ "$(uname -p)" = "arm" ] && grep -q "temurin@8" "$SCRIPT_DIR/Brewfile"; then
    info "Intel-based Java 8 (temurin@8) requires Rosetta 2"
    if ! pgrep -q oahd; then
        info "Installing Rosetta 2 for Intel compatibility"
        softwareupdate --install-rosetta --agree-to-license 2>/dev/null || info "Rosetta 2 may already be installed"
    else
        success "Rosetta 2 is already available"
    fi
fi

echo ""
info "Installing packages from Brewfile..."
if brew bundle install --file="$SCRIPT_DIR/Brewfile"; then
    success "Homebrew packages installation completed"
else
    # Try to continue with individual problematic packages
    info "Some packages may have failed, checking individual status..."

    # Check if critical Java packages failed and provide guidance
    if ! brew list --cask temurin@8 >/dev/null 2>&1; then
        info "temurin@8 installation may have failed"
        info "You can install manually with: brew install --cask temurin@8"
        info "Note: This requires Rosetta 2 on Apple Silicon Macs"
    fi

    success "Homebrew installation completed (some packages may need manual attention)"
fi

