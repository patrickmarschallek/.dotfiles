# Homebrew aliases and functions

# Get the homebrew dotfiles directory
HOMEBREW_DOTFILES_DIR="$(dirname "${(%):-%x}")"

# Aliases for common homebrew operations
alias brewfile='brew bundle install --file="$HOMEBREW_DOTFILES_DIR/Brewfile"'
alias brewcheck='$HOMEBREW_DOTFILES_DIR/check-apps.sh'
alias brewclean='brew cleanup && brew autoremove'
alias brewupdate='brew update && brew upgrade'
alias brewlock-update='brew bundle install --file="$HOMEBREW_DOTFILES_DIR/Brewfile"'
alias brewlock-regenerate='rm "$HOMEBREW_DOTFILES_DIR/Brewfile.lock.json" && brew bundle install --file="$HOMEBREW_DOTFILES_DIR/Brewfile"'

# Function to check and install missing apps
brew-install-missing() {
    echo "🔍 Checking for missing applications..."
    "$HOMEBREW_DOTFILES_DIR/check-apps.sh"
    echo ""
    read -p "Install missing applications? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "📦 Installing missing packages..."
        brew bundle install --file="$HOMEBREW_DOTFILES_DIR/Brewfile"
        echo "✅ Installation complete!"
    else
        echo "Cancelled."
    fi
}

# Function to show Brewfile status
brew-status() {
    echo "📋 Brewfile status:"
    echo "Location: $HOMEBREW_DOTFILES_DIR/Brewfile"
    echo ""
    echo "Package counts:"
    echo "  Formulae: $(grep -c '^brew ' "$HOMEBREW_DOTFILES_DIR/Brewfile" || echo 0)"
    echo "  Casks: $(grep -c '^cask ' "$HOMEBREW_DOTFILES_DIR/Brewfile" || echo 0)"
    echo "  Taps: $(grep -c '^tap ' "$HOMEBREW_DOTFILES_DIR/Brewfile" || echo 0)"
    echo ""

    # Check lock file status
    LOCK_FILE="$HOMEBREW_DOTFILES_DIR/Brewfile.lock.json"
    if [ -f "$LOCK_FILE" ]; then
        echo "🔒 Lock file: $(basename "$LOCK_FILE")"
        echo "  Last modified: $(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$LOCK_FILE" 2>/dev/null || echo "unknown")"
        echo "  Size: $(du -h "$LOCK_FILE" 2>/dev/null | cut -f1 || echo "unknown")"
    else
        echo "❌ Lock file: Missing (will be created on next install)"
    fi

    echo ""
    echo "Run 'brewcheck' to see installation status"
}

# Function to manage Brewfile lock file
brew-lock() {
    local action="${1:-help}"
    local lock_file="$HOMEBREW_DOTFILES_DIR/Brewfile.lock.json"

    case "$action" in
        "status")
            echo "🔒 Brewfile Lock Status"
            echo "======================"
            if [ -f "$lock_file" ]; then
                echo "✅ Lock file exists: $(basename "$lock_file")"
                echo "📅 Last modified: $(stat -f "%Sm" -t "%Y-%m-%d %H:%M:%S" "$lock_file" 2>/dev/null || echo "unknown")"
                echo "📊 Size: $(du -h "$lock_file" 2>/dev/null | cut -f1 || echo "unknown")"
                echo "📦 Entries: $(jq -r '.entries | length' "$lock_file" 2>/dev/null || echo "unknown")"
            else
                echo "❌ Lock file does not exist"
                echo "💡 It will be created automatically on next 'brewfile' run"
            fi
            ;;
        "update")
            echo "🔄 Updating Brewfile lock..."
            brew bundle install --file="$HOMEBREW_DOTFILES_DIR/Brewfile"
            echo "✅ Lock file updated"
            ;;
        "regenerate")
            echo "🔄 Regenerating Brewfile lock..."
            if [ -f "$lock_file" ]; then
                echo "Removing existing lock file..."
                rm "$lock_file"
            fi
            brew bundle install --file="$HOMEBREW_DOTFILES_DIR/Brewfile"
            echo "✅ Lock file regenerated"
            ;;
        "backup")
            local backup_file="${lock_file}.backup.$(date +%Y%m%d_%H%M%S)"
            if [ -f "$lock_file" ]; then
                cp "$lock_file" "$backup_file"
                echo "✅ Lock file backed up to: $(basename "$backup_file")"
            else
                echo "❌ No lock file to backup"
            fi
            ;;
        "help"|*)
            echo "Brewfile lock file management"
            echo ""
            echo "Usage: brew-lock <action>"
            echo ""
            echo "Actions:"
            echo "  status      Show lock file status and info"
            echo "  update      Update lock file with current versions"
            echo "  regenerate  Delete and recreate lock file"
            echo "  backup      Create timestamped backup"
            echo "  help        Show this help"
            echo ""
            echo "Quick aliases:"
            echo "  brewlock-update      Update lock file"
            echo "  brewlock-regenerate  Regenerate lock file"
            echo ""
            echo "What the lock file does:"
            echo "  📌 Pins exact versions of installed packages"
            echo "  🔄 Ensures reproducible installations"
            echo "  📋 Tracks package dependencies and metadata"
            ;;
    esac
}

# Help function
brew-help() {
    echo "Homebrew dotfiles helper commands:"
    echo ""
    echo "Aliases:"
    echo "  brewfile            - install packages from Brewfile"
    echo "  brewcheck           - check which apps are already installed"
    echo "  brewclean           - cleanup and remove unused packages"
    echo "  brewupdate          - update homebrew and upgrade packages"
    echo "  brewlock-update     - update Brewfile.lock.json"
    echo "  brewlock-regenerate - regenerate Brewfile.lock.json"
    echo ""
    echo "Functions:"
    echo "  brew-install-missing - interactive install of missing apps"
    echo "  brew-status         - show Brewfile statistics"
    echo "  brew-lock           - manage Brewfile.lock.json"
    echo "  brew-help           - show this help"
    echo ""
    echo "Examples:"
    echo "  brewcheck           # Check what's installed"
    echo "  brew-install-missing # Interactive install"
    echo "  brewfile            # Install all packages"
    echo "  brew-lock status    # Check lock file status"
    echo "  brewlock-update     # Update lock with current versions"
}