#!/usr/bin/env bash
#
# Hyper Terminal
#
# This installs Hyper plugins and configures the terminal

set -e

source "$(dirname "$0")/../helper.sh"

info "Setting up Hyper terminal plugins"

# Check if Hyper is installed
if ! command -v hyper >/dev/null 2>&1; then
    info "Hyper not found - it should be installed via Homebrew first"
    exit 0
fi

# Get installed plugins
installed_plugins=($(hyper ls 2>/dev/null || echo ""))

# Define plugins to install and uninstall
plugins=(hyper-font-ligatures hyper-one-dark hyperline)
uninstall=(hyper-monokai-glow)

# Temporarily backup .npmrc if it exists (prevents private repo errors)
rc_file="$HOME/.npmrc"
rc_file_backup="${rc_file}.hyper-backup"
if [[ -f "$rc_file" ]]; then
    mv "$rc_file" "$rc_file_backup"
    info "temporarily backed up .npmrc"
fi

# Install plugins
for plugin in "${plugins[@]}"; do
    if [[ " ${installed_plugins[*]} " =~ " ${plugin} " ]]; then
        success "$plugin already installed"
    else
        info "installing $plugin"
        if hyper install "$plugin" 2>/dev/null; then
            success "$plugin installed"
        else
            info "$plugin installation may have failed - check manually"
        fi
    fi
done

# Uninstall old plugins
for plugin in "${uninstall[@]}"; do
    if [[ " ${installed_plugins[*]} " =~ " ${plugin} " ]]; then
        info "uninstalling $plugin"
        hyper uninstall "$plugin" 2>/dev/null || info "$plugin uninstallation may have failed"
    fi
done

# Restore .npmrc if it was backed up
if [[ -f "$rc_file_backup" ]]; then
    mv "$rc_file_backup" "$rc_file"
    info "restored .npmrc"
fi

success "Hyper terminal configuration completed"
info "Restart Hyper terminal to see theme and plugin changes"

exit 0
