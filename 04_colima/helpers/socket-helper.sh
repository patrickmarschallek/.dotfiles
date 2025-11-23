#!/usr/bin/env bash
#
# Docker socket management helper
#

set -e

ACTION="${1:-help}"
PROFILE="${2:-default}"

case "$ACTION" in
    "link")
        echo "🔗 Linking Docker socket for profile: $PROFILE"
        if [ "$PROFILE" = "default" ]; then
            SOCKET_PATH="$HOME/.colima/default/docker.sock"
        else
            SOCKET_PATH="$HOME/.colima/$PROFILE/docker.sock"
        fi

        if [ -S "$SOCKET_PATH" ]; then
            sudo ln -sf "$SOCKET_PATH" /var/run/docker.sock
            echo "✅ Linked $SOCKET_PATH to /var/run/docker.sock"
        else
            echo "❌ Socket not found at $SOCKET_PATH"
            echo "Is colima profile '$PROFILE' running?"
            exit 1
        fi
        ;;
    "check")
        echo "🔍 Checking Docker socket configuration..."

        # Check if /var/run/docker.sock exists and what it points to
        if [ -L /var/run/docker.sock ]; then
            LINK_TARGET=$(readlink /var/run/docker.sock)
            echo "✅ /var/run/docker.sock is a symlink pointing to: $LINK_TARGET"

            if [ -S "$LINK_TARGET" ]; then
                echo "✅ Target socket exists and is accessible"
            else
                echo "❌ Target socket is not accessible"
            fi
        elif [ -S /var/run/docker.sock ]; then
            echo "ℹ️  /var/run/docker.sock exists as a regular socket"
        else
            echo "❌ /var/run/docker.sock does not exist"
        fi

        # Check colima sockets
        echo ""
        echo "Colima sockets:"
        for socket in "$HOME"/.colima/*/docker.sock; do
            if [ -S "$socket" ]; then
                profile=$(basename "$(dirname "$socket")")
                echo "✅ Profile '$profile': $socket"
            fi
        done
        ;;
    "unlink")
        echo "🔓 Removing /var/run/docker.sock symlink..."
        if [ -L /var/run/docker.sock ]; then
            sudo rm /var/run/docker.sock
            echo "✅ Symlink removed"
        else
            echo "ℹ️  No symlink to remove"
        fi
        ;;
    "fix-permissions")
        echo "🔧 Fixing Docker socket permissions..."
        for socket in "$HOME"/.colima/*/docker.sock; do
            if [ -S "$socket" ]; then
                chmod 666 "$socket" 2>/dev/null || true
                profile=$(basename "$(dirname "$socket")")
                echo "✅ Fixed permissions for profile '$profile'"
            fi
        done

        if [ -S /var/run/docker.sock ]; then
            sudo chmod 666 /var/run/docker.sock 2>/dev/null || true
            echo "✅ Fixed permissions for /var/run/docker.sock"
        fi
        ;;
    "help"|*)
        echo "Docker socket management helper"
        echo ""
        echo "Usage: $0 <action> [profile]"
        echo ""
        echo "Actions:"
        echo "  link [profile]        Link colima socket to /var/run/docker.sock"
        echo "  check                 Check socket configuration and status"
        echo "  unlink                Remove /var/run/docker.sock symlink"
        echo "  fix-permissions       Fix socket permissions"
        echo "  help                  Show this help"
        echo ""
        echo "Examples:"
        echo "  $0 link               # Link default profile socket"
        echo "  $0 link dev           # Link 'dev' profile socket"
        echo "  $0 check              # Check all socket configurations"
        ;;
esac