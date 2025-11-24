#!/usr/bin/env bash
#
# Colima
#
# This sets up colima and Docker context management

set -e

source "$(dirname "$0")/../helper.sh"

# Check if colima is available
if command -v colima >/dev/null 2>&1; then
    # Check if colima is running, if not start it
    if ! colima status >/dev/null 2>&1; then
        info "starting colima"
        colima start --cpu 4 --memory 8 --disk 60 --network-address

        # Link Docker socket to standard location (may need sudo)
        if [ ! -L "/var/run/docker.sock" ] || [ ! -e "/var/run/docker.sock" ]; then
            info "linking Docker socket to /var/run/docker.sock"
            sudo ln -sf "$HOME/.colima/default/docker.sock" /var/run/docker.sock 2>/dev/null || info "Docker socket linking may need manual attention"
        fi
    else
        success "colima is already running"
    fi

    # Set up Docker context if docker is available
    if command -v docker >/dev/null 2>&1; then
        if ! docker context ls 2>/dev/null | grep -q "colima"; then
            info "configuring Docker context for colima"
            docker context create colima --docker "host=unix://$HOME/.colima/default/docker.sock" || info "Docker context creation may need manual attention"
        fi

        # Use colima as default Docker context
        docker context use colima 2>/dev/null || info "Setting Docker context may need manual attention"
    fi

    success "colima setup completed"
else
    info "colima not found - it should be installed via Homebrew first"
fi

# Make helper scripts executable
chmod +x "$(dirname "$0")/helpers/"*.sh 2>/dev/null || true

exit 0