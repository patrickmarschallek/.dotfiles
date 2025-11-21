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

echo ""
info "Installing packages from Brewfile..."
brew bundle install --file="$SCRIPT_DIR/Brewfile"
success "Homebrew packages installation completed"

