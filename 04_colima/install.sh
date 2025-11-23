#!/usr/bin/env bash
#
# Colima
#
# This sets up colima and Docker context management

set -e

source "$(dirname "$0")/../helper.sh"

# Check if colima is already installed and configured
if command -v colima >/dev/null 2>&1 && colima status >/dev/null 2>&1; then
    success "colima is already running"
else
    info "setting up colima"

    # Start colima with default configuration
    if ! colima status >/dev/null 2>&1; then
        info "starting colima for the first time with network address"
        colima start --cpu 4 --memory 8 --disk 60 --network-address

        # Link Docker socket to standard location
        info "linking Docker socket to /var/run/docker.sock"
        sudo ln -sf "$HOME/.colima/default/docker.sock" /var/run/docker.sock
    fi

    # Set up Docker context
    if ! docker context ls | grep -q "colima"; then
        info "configuring Docker context for colima"
        docker context create colima --docker "host=unix://$HOME/.colima/default/docker.sock"
    fi

    # Use colima as default Docker context
    docker context use colima

    success "colima setup completed"
fi

# Make helper scripts executable
chmod +x "$(dirname "$0")/helpers/"*.sh 2>/dev/null || true

exit 0