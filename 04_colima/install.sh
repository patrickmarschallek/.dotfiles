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

        # Link Docker socket to standard location (only if needed)
        if [ ! -L "/var/run/docker.sock" ] || [ ! -e "/var/run/docker.sock" ]; then
            info "linking Docker socket to /var/run/docker.sock"
            info "This requires administrator privileges"

            # Check if we can write to /var/run without sudo first
            if touch /var/run/.colima-test 2>/dev/null; then
                rm -f /var/run/.colima-test
                ln -sf "$HOME/.colima/default/docker.sock" /var/run/docker.sock
                success "Docker socket linked without sudo"
            else
                # Only request sudo if actually needed
                if sudo ln -sf "$HOME/.colima/default/docker.sock" /var/run/docker.sock 2>/dev/null; then
                    success "Docker socket linked with administrator privileges"
                else
                    info "Docker socket linking failed - you may need to run manually:"
                    info "  sudo ln -sf \$HOME/.colima/default/docker.sock /var/run/docker.sock"
                fi
            fi
        else
            success "Docker socket already properly linked"
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