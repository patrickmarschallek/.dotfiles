#!/usr/bin/env bash
#
# Check if applications are already installed before running brew bundle
#

source "$(dirname "$0")/../helper.sh"

# Function to check if a cask application is installed
check_cask_installed() {
    local cask_name="$1"
    local app_name="$2"

    if [ -d "/Applications/$app_name.app" ]; then
        success "$app_name is already installed"
        return 0
    else
        info "$app_name not found, will be installed"
        return 1
    fi
}

# Function to check if a brew formula is installed
check_brew_installed() {
    local formula_name="$1"

    if brew list "$formula_name" >/dev/null 2>&1; then
        success "$formula_name is already installed"
        return 0
    else
        info "$formula_name not found, will be installed"
        return 1
    fi
}

echo "🔍 Checking installation status of key applications..."
echo ""

# Check development tools
echo "=== Development Tools ==="
check_cask_installed "obsidian" "Obsidian"
check_cask_installed "datagrip" "DataGrip"
check_cask_installed "intellij-idea" "IntelliJ IDEA"
check_cask_installed "visual-studio-code" "Visual Studio Code"
check_cask_installed "postman" "Postman"

echo ""
echo "=== Container Tools ==="
check_brew_installed "colima"
check_brew_installed "docker"

echo ""
echo "=== Java Development ==="
check_cask_installed "temurin@11" "Eclipse Temurin 11"
check_cask_installed "temurin@17" "Eclipse Temurin 17"
check_cask_installed "temurin@21" "Eclipse Temurin 21"

echo ""
echo "=== AI Development Tools ==="
check_brew_installed "claude-code"
check_brew_installed "ollama"

echo ""
echo "=== Terminal Tools ==="
check_cask_installed "hyper" "Hyper"

echo ""
echo "💡 Run 'brew bundle install --file=\"01_homebrew/Brewfile\"' to install missing applications"