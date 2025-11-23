#!/usr/bin/env bash
# Sets reasonable macOS defaults.
#
# Or, in other words, set shit how I like in macOS.
#
# The original idea (and a couple settings) were grabbed from:
#   https://github.com/mathiasbynens/dotfiles/blob/master/.macos
#
# Run ./set-defaults.sh and you'll be good to go.
#
# ADDING SYSTEM-LEVEL SETTINGS:
# To add settings that require elevated privileges:
# 1. Update check_elevation_needed() to return 0 when sudo is needed
# 2. Use apply_system_setting() function for sudo commands
# 3. Test thoroughly as system settings can affect all users

set -e

# Colors for output
if [[ -t 1 ]]; then
    RED='\033[0;31m'
    GREEN='\033[0;32m'
    YELLOW='\033[1;33m'
    BLUE='\033[0;34m'
    NC='\033[0m' # No Color
else
    RED=''
    GREEN=''
    YELLOW=''
    BLUE=''
    NC=''
fi

info() {
    echo -e "${BLUE}[macOS Defaults]${NC} $1"
}

success() {
    echo -e "${GREEN}✅${NC} $1"
}

warn() {
    echo -e "${YELLOW}⚠️${NC} $1"
}

error() {
    echo -e "${RED}❌${NC} $1"
}

# Check if we need elevated privileges for any system-level settings
check_elevation_needed() {
    # Check for common system-level settings that would require sudo
    # These include security settings, system-wide configurations, etc.

    # Example conditions that would require sudo:
    # if [[ "$ENABLE_SYSTEM_SETTINGS" == "true" ]]; then
    #     return 0  # Elevation needed
    # fi

    # Examples of settings that would need sudo (not currently implemented):
    # - Security settings: sudo spctl --master-disable
    # - Network settings: sudo networksetup -setdnsservers Wi-Fi 8.8.8.8
    # - Login window settings: sudo defaults write /Library/Preferences/com.apple.loginwindow
    # - Energy saver settings: sudo pmset -a displaysleep 15

    # For current user defaults, no elevation is needed
    return 1  # No elevation needed for current settings
}

# Request sudo access if needed
request_elevation() {
    if check_elevation_needed; then
        info "Some settings require administrator privileges"
        if ! sudo -v; then
            error "Administrator access required but not granted"
            exit 1
        fi

        # Keep sudo session alive
        while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    fi
}

# Apply a default setting with error handling
apply_default() {
    local domain="$1"
    local key="$2"
    local value="$3"
    local type="${4:-}"
    local description="$5"

    info "Setting: $description"

    if [[ -n "$type" ]]; then
        if defaults write "$domain" "$key" $type "$value" 2>/dev/null; then
            success "Applied: $description"
        else
            warn "Failed to apply: $description"
        fi
    else
        if defaults write "$domain" "$key" "$value" 2>/dev/null; then
            success "Applied: $description"
        else
            warn "Failed to apply: $description"
        fi
    fi
}

# Apply a system-level setting that requires sudo
apply_system_setting() {
    local command="$1"
    local description="$2"

    info "System setting: $description"

    if eval "$command" 2>/dev/null; then
        success "Applied: $description"
    else
        warn "Failed to apply: $description"
    fi
}

info "Configuring macOS defaults..."

# Request elevation if needed
request_elevation

# Always open everything in Finder's list view. This is important.
apply_default "com.apple.Finder" "FXPreferredViewStyle" "Nlsv" "" "Finder list view as default"

# Set the Finder prefs for showing a few different volumes on the Desktop.
apply_default "com.apple.finder" "ShowExternalHardDrivesOnDesktop" "true" "-bool" "Show external drives on desktop"
apply_default "com.apple.finder" "ShowRemovableMediaOnDesktop" "true" "-bool" "Show removable media on desktop"

# Disable automatically rearrange Spaces based on recent use
apply_default "com.apple.dock" "mru-spaces" "false" "-bool" "Disable automatic Space rearrangement"

# Additional useful macOS defaults
apply_default "NSGlobalDomain" "AppleShowAllExtensions" "true" "-bool" "Show all file extensions"
apply_default "com.apple.finder" "AppleShowAllFiles" "true" "-bool" "Show hidden files in Finder"
apply_default "com.apple.finder" "FXDefaultSearchScope" "SCcf" "" "Search current folder by default"
apply_default "com.apple.finder" "_FXShowPosixPathInTitle" "true" "-bool" "Show full path in Finder title bar"
apply_default "NSGlobalDomain" "NSNavPanelExpandedStateForSaveMode" "true" "-bool" "Expand save dialog by default"
apply_default "NSGlobalDomain" "PMPrintingExpandedStateForPrint" "true" "-bool" "Expand print dialog by default"

# Dock settings
apply_default "com.apple.dock" "autohide" "true" "-bool" "Auto-hide the Dock"
apply_default "com.apple.dock" "autohide-delay" "0" "-float" "Remove Dock auto-hide delay"
apply_default "com.apple.dock" "autohide-time-modifier" "0.5" "-float" "Speed up Dock auto-hide animation"

# Trackpad settings
apply_default "com.apple.driver.AppleBluetoothMultitouch.trackpad" "Clicking" "true" "-bool" "Enable trackpad tap to click"
apply_default "NSGlobalDomain" "com.apple.mouse.tapBehavior" "1" "-int" "Enable tap to click for login screen"

info "macOS defaults configuration complete!"

# Restart affected applications for changes to take effect
info "Restarting Finder and Dock to apply changes..."
if killall Finder 2>/dev/null; then
    success "Finder restarted"
else
    warn "Could not restart Finder"
fi

if killall Dock 2>/dev/null; then
    success "Dock restarted"
else
    warn "Could not restart Dock"
fi

success "macOS defaults have been applied!"
