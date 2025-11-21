#!/usr/bin/env bash
#
# Colima upgrade and VM recreation helper
#

set -e

ACTION="${1:-help}"

case "$ACTION" in
    "upgrade")
        echo "🔄 Upgrading Colima..."

        # Stop colima if running
        if colima status >/dev/null 2>&1; then
            echo "Stopping colima..."
            colima stop
        fi

        # Upgrade via Homebrew
        echo "Upgrading colima via Homebrew..."
        brew upgrade colima

        # Start colima again
        echo "Starting colima..."
        colima start --cpu 4 --memory 8 --disk 60 --network-address

        # Re-link socket
        echo "Re-linking Docker socket..."
        sudo ln -sf "$HOME/.colima/default/docker.sock" /var/run/docker.sock

        # Verify Docker context
        if docker context ls | grep -q "colima"; then
            docker context use colima
        fi

        echo "✅ Colima upgrade completed"
        ;;
    "recreate"|"recreate-vm")
        PROFILE="${2:-default}"
        CPU="${3:-4}"
        MEMORY="${4:-8}"
        DISK="${5:-60}"

        echo "🔄 Recreating Colima VM for profile: $PROFILE"
        echo "⚠️  This will delete all containers and images!"

        read -p "Are you sure you want to continue? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Cancelled."
            exit 0
        fi

        # Stop and delete
        if [ "$PROFILE" = "default" ]; then
            echo "Stopping and deleting default profile..."
            colima stop || true
            colima delete || true
        else
            echo "Stopping and deleting profile: $PROFILE"
            colima stop --profile "$PROFILE" || true
            colima delete --profile "$PROFILE" || true
        fi

        # Recreate with specified resources
        echo "Recreating VM with $CPU CPUs, ${MEMORY}GB RAM, ${DISK}GB disk..."
        if [ "$PROFILE" = "default" ]; then
            colima start --cpu "$CPU" --memory "$MEMORY" --disk "$DISK" --network-address
            # Re-link socket for default profile
            sudo ln -sf "$HOME/.colima/default/docker.sock" /var/run/docker.sock
        else
            colima start --profile "$PROFILE" --cpu "$CPU" --memory "$MEMORY" --disk "$DISK" --network-address
            # Link socket for named profile
            sudo ln -sf "$HOME/.colima/$PROFILE/docker.sock" /var/run/docker.sock
        fi

        echo "✅ VM recreation completed for profile: $PROFILE"
        ;;
    "quick-recreate")
        echo "🚀 Quick VM recreation with default resources..."
        echo "⚠️  This will delete all containers and images!"

        read -p "Continue with 2 CPU, 4GB RAM? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            $0 recreate default 2 4 60
        else
            echo "Cancelled."
        fi
        ;;
    "check-version")
        echo "📋 Colima version information:"
        if command -v colima >/dev/null 2>&1; then
            colima version
            echo ""

            # Check if there's an update available
            echo "Checking for updates..."
            CURRENT_VERSION=$(colima version 2>/dev/null | head -1 | awk '{print $3}' || echo "unknown")
            if command -v brew >/dev/null 2>&1; then
                echo "Current version: $CURRENT_VERSION"
                echo "Available version: $(brew info colima | grep "colima:" | awk '{print $3}' | head -1)"
                echo ""
                echo "Run 'clm-upgrade upgrade' to upgrade colima"
            fi
        else
            echo "❌ Colima not installed"
        fi
        ;;
    "help"|*)
        echo "Colima upgrade and maintenance helper"
        echo ""
        echo "Usage: $0 <action> [args...]"
        echo ""
        echo "Actions:"
        echo "  upgrade                           Upgrade colima and restart"
        echo "  recreate [profile] [cpu] [mem] [disk]  Recreate VM with custom resources"
        echo "  quick-recreate                    Quick recreate with 2 CPU, 4GB RAM"
        echo "  check-version                     Check current and available versions"
        echo "  help                              Show this help"
        echo ""
        echo "Examples:"
        echo "  $0 upgrade                        # Upgrade colima"
        echo "  $0 recreate                       # Recreate default profile with 4 CPU, 8GB"
        echo "  $0 recreate dev 6 12 80          # Recreate 'dev' profile with custom resources"
        echo "  $0 quick-recreate                 # Quick recreate with minimal resources"
        echo ""
        echo "💡 VM recreation is useful when:"
        echo "   - Colima is behaving unexpectedly"
        echo "   - After major colima upgrades"
        echo "   - To change base VM configuration"
        ;;
esac