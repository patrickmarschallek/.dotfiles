#!/usr/bin/env bash
#
# Start colima with custom configuration
#

set -e

PROFILE="${1:-default}"
CPU="${2:-4}"
MEMORY="${3:-8}"
DISK="${4:-60}"

echo "Starting colima profile: $PROFILE"
echo "  CPU: $CPU cores"
echo "  Memory: ${MEMORY}GB"
echo "  Disk: ${DISK}GB"

if [ "$PROFILE" = "default" ]; then
    colima start --cpu "$CPU" --memory "$MEMORY" --disk "$DISK" --network-address
else
    colima start --profile "$PROFILE" --cpu "$CPU" --memory "$MEMORY" --disk "$DISK" --network-address
fi

# Link Docker socket to standard location for compatibility
echo "Linking Docker socket to /var/run/docker.sock..."
if [ "$PROFILE" = "default" ]; then
    sudo ln -sf "$HOME/.colima/default/docker.sock" /var/run/docker.sock
else
    sudo ln -sf "$HOME/.colima/$PROFILE/docker.sock" /var/run/docker.sock
fi

# Set up Docker context for this profile
CONTEXT_NAME="colima-$PROFILE"
if ! docker context ls | grep -q "$CONTEXT_NAME"; then
    if [ "$PROFILE" = "default" ]; then
        docker context create colima --docker "host=unix://$HOME/.colima/default/docker.sock"
    else
        docker context create "$CONTEXT_NAME" --docker "host=unix://$HOME/.colima/$PROFILE/docker.sock"
    fi
fi

# Switch to this context
if [ "$PROFILE" = "default" ]; then
    docker context use colima
else
    docker context use "$CONTEXT_NAME"
fi

echo "✅ Colima profile '$PROFILE' started and Docker context configured"