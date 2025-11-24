#!/usr/bin/env bash
#
# Java
#
# This configures Java versions with jenv

set -e

source "$(dirname "$0")/../helper.sh"

# Check if jenv is available
if ! command -v jenv >/dev/null 2>&1; then
    info "jenv not installed - skipping Java configuration"
    exit 0
fi

info "configuring Java versions with jenv"

# Enable export plugin first (idempotent)
jenv enable-plugin export 2>/dev/null || true

# Function to add Java version to jenv if not already added
add_java_if_new() {
    local java_path="$1"
    local version_name="$2"

    if [ -d "$java_path" ]; then
        if ! jenv versions 2>/dev/null | grep -q "$java_path"; then
            info "adding $version_name to jenv"
            jenv add "$java_path" 2>/dev/null && success "$version_name added" || info "$version_name may already be configured"
        else
            success "$version_name already configured"
        fi
    fi
}

# Add Temurin versions (these come from the casks in Brewfile)
for version in 8 11 17 21; do
    add_java_if_new "/Library/Java/JavaVirtualMachines/temurin-${version}.jdk/Contents/Home" "Temurin $version"
done

success "Java configuration completed"
exit 0
