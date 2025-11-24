#!/usr/bin/env bash
#
# Java
#
# This installs java versions and registers them to jenv

set -e

source "$(dirname "$0")/../helper.sh"

# Check if jenv is available
if ! command -v jenv >/dev/null 2>&1; then
    info "jenv not found - it should be installed via Homebrew first"
    exit 0
fi

info "configuring Java versions with jenv"

# Add Temurin versions from casks (preferred over OpenJDK)
for version in 8 11 17 21; do
    temurin_path="/Library/Java/JavaVirtualMachines/temurin-${version}.jdk/Contents/Home"
    if [ -d "$temurin_path" ]; then
        # Check if this version is already added to avoid duplicates
        if ! jenv versions | grep -q "$temurin_path"; then
            info "adding Temurin $version to jenv"
            jenv add "$temurin_path" || info "Temurin $version may already be configured"
            success "Temurin $version configured"
        else
            success "Temurin $version already configured in jenv"
        fi
    else
        info "Temurin $version not found at $temurin_path (may not be installed)"
    fi
done

# Fallback: Add any OpenJDK versions from Homebrew if they exist
HOMEBREW_DIR="$(brew --prefix)/Cellar"
if [ -d "$HOMEBREW_DIR" ]; then
    info "checking for Homebrew OpenJDK versions"
    for openjdk_path in "$HOMEBREW_DIR"/openjdk*/*/libexec/openjdk.jdk/Contents/Home; do
        if [ -d "$openjdk_path" ]; then
            if ! jenv versions | grep -q "$openjdk_path"; then
                info "adding OpenJDK from $openjdk_path to jenv"
                jenv add "$openjdk_path" 2>/dev/null || info "OpenJDK at $openjdk_path may already be configured"
            fi
        fi
    done
fi

# Enable export plugin (idempotent)
info "enabling jenv export plugin"
jenv enable-plugin export 2>/dev/null || success "jenv export plugin already enabled"

success "Java configuration completed"
exit 0
