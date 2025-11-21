#!/usr/bin/env bash
#
# Streamlined Remote Dotfiles Installer
# Usage: curl -fsSL https://raw.githubusercontent.com/patrickmarschallek/.dotfiles/main/install-remote.sh | bash
#
# This script:
# 1. Installs git and downloads dotfiles repository
# 2. Sets up automatic resume mechanism for macOS restarts
# 3. Runs the main installation via bin/dot
#

set -e

# Configuration
DOTFILES_REPO="https://github.com/patrickmarschallek/.dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"
INSTALL_LOG="$HOME/.dotfiles-install.log"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log() {
    echo -e "${BLUE}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$INSTALL_LOG"
}

success() {
    echo -e "${GREEN}✅ $1${NC}" | tee -a "$INSTALL_LOG"
}

warn() {
    echo -e "${YELLOW}⚠️  $1${NC}" | tee -a "$INSTALL_LOG"
}

error() {
    echo -e "${RED}❌ $1${NC}" | tee -a "$INSTALL_LOG"
}

# Check if we're on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    error "This script is designed for macOS only"
    exit 1
fi

log "Starting streamlined dotfiles installation..."

# Install Xcode Command Line Tools (includes git)
if ! command -v git &> /dev/null; then
    log "Installing Xcode Command Line Tools..."
    xcode-select --install

    # Wait for installation to complete
    until command -v git &> /dev/null; do
        log "Waiting for git installation..."
        sleep 5
    done
    success "Git installed"
else
    success "Git already available"
fi

# Clone or update dotfiles repository
if [ -d "$DOTFILES_DIR" ]; then
    log "Updating existing dotfiles repository..."
    cd "$DOTFILES_DIR"
    git pull origin main
else
    log "Cloning dotfiles repository..."
    git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
fi

success "Dotfiles repository ready at $DOTFILES_DIR"

# Set up resume mechanism using the dotfiles resume script
log "Setting up automatic resume mechanism..."
cd "$DOTFILES_DIR"

# Make resume script executable
chmod +x bin/dotfiles-resume

# Set up launch agent using the dotfiles resume script
bin/dotfiles-resume setup

success "Resume mechanism configured"

# Run the main installation
log "Running main installation via bin/dot..."
bin/dot

# If we get here without restart, installation is complete
success "🎉 Dotfiles installation completed successfully!"

echo ""
echo "📋 Installation Summary:"
echo "  • Dotfiles installed to: $DOTFILES_DIR"
echo "  • Installation log: $INSTALL_LOG"
echo "  • Management command: bin/dot"
echo ""
echo "🚀 Next steps:"
echo "  1. Restart your terminal or run: source ~/.zshrc"
echo "  2. Run 'dotfiles-registry summary' to see available tools"
echo "  3. Run 'bin/dot' anytime to update"